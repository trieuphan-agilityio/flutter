import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';

abstract class CreativeDownloader {
  addCreative(Creative creative);
  Stream<Creative> downloadedCreative$;
}

class CreativeDownloaderImpl implements CreativeDownloader {
  final Config _config;
  final StreamController<Creative> _controller;
  final HttpClient _http;

  final _TaskQueue taskQueue;
  final _TaskQueue videoTaskQueue;

  CreativeDownloaderImpl(Config config)
      : _config = config,
        _controller = StreamController<Creative>(),
        _http = HttpClient(),
        taskQueue = _TaskQueue(
          config.creativeDownloadParallelTasks,
          Duration(seconds: config.creativeDownloadTimeout),
        ),
        videoTaskQueue = _TaskQueue(
          config.videoCreativeDownloadParallelTasks,
          Duration(seconds: config.videoCreativeDownloadTimeout),
        );

  addCreative(Creative creative) {
    if (creative is VideoCreative) {
      _addVideoCreative(creative);
    } else {
      _addCreative(creative);
    }
  }

  _addVideoCreative(VideoCreative creative) {
    videoTaskQueue.add(creative.id, () async {
      final completer = Completer<Creative>();
      await Future.value(creative);
      return completer.future;
    });
  }

  _addCreative(Creative creative) {
    taskQueue.add(creative.id, () async {
      final completer = Completer<Creative>();
      await Future.value(creative);
      return completer.future;
    });
  }

  @override
  Stream<Creative> downloadedCreative$;
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

  Future add(String id, Function f) {
    Log.info('CreativeDownloader adds task $id');
    final task = _Task(id, f, timeout);
    queue.add(task);
    return null;
  }

  /// execute next task if any
  void work() {
    if (_availableSlots > 0 && queue.isNotEmpty) {
      _availableSlots--;

      _Task task = queue.removeFirst();
    }
  }

  /// Indicates number of slots available for executing more tasks.
  int _availableSlots;
}

class _Task {
  final String id;
  final Function f;
  final Duration timeout;

  _Task(this.id, this.f, this.timeout);
}
