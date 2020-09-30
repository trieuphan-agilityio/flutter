import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:ad_bloc/base.dart';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

abstract class FileDownloader {
  /// - [metadata] an optional data object that is bring along with downloader,
  ///   and it will be included in the result [file$] stream.
  enqueue(String fileUrl, String saveToPath, Object metadata);

  /// Remove a [fileUrl] from the queue.
  unqueue(String fileUrl);

  /// File that has just been downloaded.
  Stream<DownloadedFile> get file$;
}

class FakeFileDownloader implements FileDownloader {
  final StreamController<DownloadedFile> _controller;

  FakeFileDownloader()
      : _controller = StreamController<DownloadedFile>.broadcast();

  Stream<DownloadedFile> get file$ => _controller.stream;

  enqueue(String fileUrl, String saveToPath, Object metadata) {
    // simulate downloading delay 300ms - 5s.
    Timer(Duration(milliseconds: _random.nextInt(4700) + 300), () {
      _controller.add(DownloadedFile(
        fileUrl: fileUrl,
        filePath: saveToPath,
        metadata: metadata,
        createdAt: DateTime.now(),
      ));
    });
  }

  unqueue(String filePath) {
    /// do nothing.
  }

  final Random _random = Random();
}

const int _kParallelTasks = 1;
const int _kTimeoutSecs = 30;

class FileDownloaderImpl implements FileDownloader {
  final FileUrlResolver fileUrlResolver;
  final FilePathResolver filePathResolver;
  final DownloadOptions options;

  final StreamController<DownloadedFile> _downloadedFile$Controller;
  final HttpClient _http;
  final _TaskQueue _taskQueue;

  FileDownloaderImpl(
      {this.fileUrlResolver, this.filePathResolver, this.options})
      : _http = HttpClient(),
        _downloadedFile$Controller = StreamController.broadcast(),
        _taskQueue = _TaskQueue(
          options?.numOfParallelTasks ?? _kParallelTasks,
          Duration(seconds: options?.timeoutSecs ?? _kTimeoutSecs),
        );

  enqueue(String fileUrl, String saveToPath, Object metadata) {
    _taskQueue.add(fileUrl, () async {
      // file url to download
      final resolvedFileUrl =
          await fileUrlResolver?.resolve(fileUrl) ?? fileUrl;

      // file path to save file on local file system
      final resolvedFilePath =
          await filePathResolver?.resolve(saveToPath) ?? saveToPath;
      final filePathOnDownloading = '$resolvedFilePath.part';

      final completer = Completer();

      // prefer cache file if exists
      if (File(resolvedFilePath).existsSync()) {
        // inform status stream
        _downloadedFile$Controller.add(DownloadedFile(
          fileUrl: resolvedFileUrl,
          filePath: resolvedFilePath,
          metadata: metadata,
          createdAt: DateTime.now(),
        ));

        // complete the work on task queue
        completer.complete();
        return;
      }

      // create temp file for the downloading as well as its folder.
      File(filePathOnDownloading).createSync(recursive: true);

      _http
          .getUrl(Uri.parse(resolvedFileUrl))
          .then((HttpClientRequest req) => req.close())
          .then((HttpClientResponse res) {
        // write to .part file
        return res.pipe(File(filePathOnDownloading).openWrite());
      }).then((_) async {
        // complete downloading file
        File(filePathOnDownloading).copySync(resolvedFilePath);

        // inform status stream
        _downloadedFile$Controller.add(DownloadedFile(
          fileUrl: resolvedFileUrl,
          filePath: resolvedFilePath,
          metadata: metadata,
          createdAt: DateTime.now(),
        ));

        // complete the work on task queue
        completer.complete();
      }).catchError((err) {
        Log.warn(err.toString());
        completer.completeError(err);
      }).whenComplete(() {
        try {
          File(filePathOnDownloading).deleteSync();
        } catch (_) {}
      });
      return completer.future;
    });
  }

  unqueue(String filePath) {
    _taskQueue.remove(filePath);
  }

  Stream<DownloadedFile> get file$ => _downloadedFile$Controller.stream;
}

class _TaskQueue {
  Queue queue = Queue();

  /// Number of tasks that can be parallel executed when enqueue.
  final int parallelTasks;

  /// [timeout] indicates time budget for each task to finish.
  /// It would throw error when execution is delayed longer than [timeout].
  final Duration timeout;

  _TaskQueue(this.parallelTasks, this.timeout)
      : _availableSlots = parallelTasks;

  add(String id, Function f) {
    final task = _Task(id, f, timeout);
    queue.add(task);

    // start the work after adding a new task.
    Future(work);
  }

  /// Remove by task id.
  remove(String id) {
    queue.removeWhere((task) => task.id == id);
  }

  /// execute next task if any
  void work() {
    if (_availableSlots == 0 || queue.isEmpty) {
      return;
    }

    // take a slot
    _availableSlots--;

    _Task task = queue.removeFirst();
    Future(task.run).catchError((err) {
      if (!task.completer.isCompleted) {
        task.completer.completeError(err);
      }
    }).then((_) {
      if (!task.completer.isCompleted) {
        task.completer.complete();
      }
    }).whenComplete(() {
      // free up the slot
      _availableSlots++;

      // start another work
      Future(work);
    });
  }

  /// Indicates number of slots available for executing more tasks.
  int _availableSlots;
}

/// [Task] that has a [run] method with a [timeout].
class _Task {
  final String id;
  final Function run;
  final Duration timeout;

  final Completer completer;

  _Task(this.id, this.run, this.timeout) : completer = Completer() {
    completer.future.timeout(timeout, onTimeout: () {
      if (!completer.isCompleted) {
        completer.completeError('$id timed out');
      }
    })
        // future.timeout creates a new Future which also throws when
        // the completer is completed with completeError
        // not handling this error ends the app with unhandled exception
        .catchError((_) {});
  }
}

class DownloadOptions {
  final int numOfParallelTasks;
  final int timeoutSecs;

  DownloadOptions({this.numOfParallelTasks, this.timeoutSecs});
}

class DownloadedFile {
  final String fileUrl;
  final String filePath;
  final Object metadata;
  final DateTime createdAt;

  DownloadedFile({
    @required this.fileUrl,
    @required this.filePath,
    @required this.metadata,
    @required this.createdAt,
  });

  @override
  String toString() {
    return 'DownloadedFile{fileUrl: $fileUrl'
        ', filePath: $filePath'
        ', metadata: $metadata'
        ', createdAt: $createdAt}';
  }
}

String _normalizeFilePath(String filePath) {
  final trimmed = filePath.startsWith('/') ? filePath.substring(1) : filePath;
  return trimmed.replaceAll(new RegExp(r'//'), '/');
}

/// [FileUrlResolver] translate a logical file url into an full url
/// with schema, host, port, path.
///
/// [FileDownloader] use this to figure out the file to download from
/// Asset Server.
abstract class FileUrlResolver {
  FutureOr<String> resolve(String fileUrl);
}

class FileUrlResolverImpl implements FileUrlResolver {
  FileUrlResolverImpl();

  static const numOfSampleImages = 10;
  static const sampleImages = [
    'p0.jpg',
    'p1.jpg',
    'p2.jpg',
    'p3.jpg',
    'p4.jpg',
    'p5.jpg',
    'p6.jpg',
    'p7.jpg',
    'p8.jpg',
    'p9.jpg',
  ];

  static const numOfSampleVideos = 7;
  static const sampleVideos = [
    'v0.mp4',
    'v1.mp4',
    'v2.mp4',
    'v3.mp4',
    'v4.mp4',
    'v5.mp4',
    'v6.mp4',
  ];

  static const fixedZips = [];

  static const baseUrl =
      'https://lorem-picsum.s3-ap-southeast-1.amazonaws.com/ad-stream';

  @override
  FutureOr<String> resolve(String fileUrl) {
    final normalized = _normalizeFilePath(fileUrl);
    if (normalized.endsWith('.jpg')) {
      return resolveImage(normalized);
    }
    if (normalized.endsWith('.mp4')) {
      return resolveVideo(normalized);
    }
    return '$baseUrl/$normalized';
  }

  resolveImage(String fileUrl) {
    // randomly pick an image from the pre-defined list.
    final image = sampleImages[_randomCode(fileUrl) % numOfSampleImages];
    return '$baseUrl/$image';
  }

  resolveVideo(String fileUrl) {
    // randomly pick an video from the pre-defined list.
    final video = sampleVideos[_randomCode(fileUrl) % numOfSampleVideos];
    return '$baseUrl/$video';
  }

  int _randomCode(String fileUrl) {
    return int.parse(
        sha1.convert(utf8.encode(fileUrl)).toString().substring(0, 1),
        radix: 16);
  }
}

/// [FilePathResolver] translates relative file path into the platform-specific
/// absolute path.
///
/// Typically the resolved file path would be in Cache directory or
/// in a Document directory.
abstract class FilePathResolver {
  FutureOr<String> resolve(String filePath);
}

class FilePathResolverImpl implements FilePathResolver {
  FilePathResolverImpl();

  @override
  FutureOr<String> resolve(String filePath) async {
    Directory appDocDir = await getTemporaryDirectory();
    return '${appDocDir.path}/${_normalizeFilePath(filePath)}';
  }
}
