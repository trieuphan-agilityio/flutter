import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/downloader/file_downloader.dart';

abstract class CreativeDownloader {
  download(Creative creative);
  Stream<Creative> get downloaded$;
}

class ChainDownloaderImpl implements CreativeDownloader {
  final List<CreativeDownloader> _downloaders;

  ChainDownloaderImpl(this._downloaders);

  download(Creative creative) {
    // send creative for each downloader.
    // once of these would be able to process it.
    _downloaders.forEach((d) => d.download);
  }

  Stream<Creative> get downloaded$ {
    /// merge all streams which contains the downloaded content of
    /// 1. Youtube (which emit immediately since it don't need to download)
    /// 2. File, includes Image and Html bundle.
    /// 3. Video.
    return _downloaded$ ??= StreamController<Creative>()
        .stream
        .mergeAll(_downloaders.map((d) => d.downloaded$));
  }

  /// A cache instance of downloaded stream.
  Stream<Creative> _downloaded$;
}

class ImageCreativeDownloader implements CreativeDownloader {
  final FileDownloader _downloader;
  final StreamController<Creative> _controller;

  ImageCreativeDownloader(this._downloader)
      : _controller = StreamController<Creative>.broadcast() {
    _downloader.file$.listen((downloadedFile) {
      final dynamic metadata = downloadedFile.metadata;
      if (metadata is ImageCreative) {
        final c = metadata.copyWith(filePath: downloadedFile.filePath);
        _controller.add(c);
      }
    });
  }

  download(Creative creative) {
    if (creative is ImageCreative) {
      _downloader.enqueue(
        fileUrl: creative.urlPath,
        saveToPath: '/image/${creative.urlPath}',
        metadata: creative,
      );
    }
  }

  Stream<Creative> get downloaded$ => _controller.stream;
}

class VideoCreativeDownloader implements CreativeDownloader {
  final FileDownloader _downloader;
  final StreamController<Creative> _controller;

  VideoCreativeDownloader(this._downloader)
      : _controller = StreamController<Creative>.broadcast() {
    _downloader.file$.listen((downloadedFile) {
      final dynamic metadata = downloadedFile.metadata;
      if (metadata is VideoCreative) {
        final c = metadata.copyWith(filePath: downloadedFile.filePath);
        _controller.add(c);
      }
    });
  }

  download(Creative creative) {
    if (creative is VideoCreative) {
      _downloader.enqueue(
        fileUrl: creative.urlPath,
        saveToPath: '/video/${creative.urlPath}',
        metadata: creative,
      );
    }
  }

  Stream<Creative> get downloaded$ => _controller.stream;
}

class HtmlCreativeDownloader implements CreativeDownloader {
  final FileDownloader _downloader;
  final StreamController<Creative> _controller;

  HtmlCreativeDownloader(this._downloader)
      : _controller = StreamController<Creative>.broadcast() {
    _downloader.file$.listen((downloadedFile) async {
      final dynamic metadata = downloadedFile.metadata;
      if (metadata is HtmlCreative) {
        // unzip before emitting to the stream.
        final folderPath = await _unzip(downloadedFile.filePath);
        final c = metadata.copyWith(filePath: folderPath);
        _controller.add(c);
      }
    });
  }

  /// Unzip the .zip file and complete the future with string of the root folder.
  Future<String> _unzip(String filePath) async {
    // TODO unzip the bundle file
    return null;
  }

  download(Creative creative) {
    if (creative is HtmlCreative) {
      _downloader.enqueue(
        fileUrl: creative.urlPath,
        saveToPath: '/html/${creative.urlPath}',
        metadata: creative,
      );
    }
  }

  Stream<Creative> get downloaded$ => _controller.stream;
}

class YoutubeCreativeDownloader implements CreativeDownloader {
  final StreamController<Creative> _controller;

  YoutubeCreativeDownloader()
      : _controller = StreamController<Creative>.broadcast();

  download(Creative creative) {
    if (creative is YoutubeCreative) {
      // no need to download youtube creative.
      // just forward it.
      _controller.add(creative);
    }
  }

  Stream<Creative> get downloaded$ => _controller.stream;
}
