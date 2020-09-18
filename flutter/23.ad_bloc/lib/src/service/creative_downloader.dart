import 'dart:async';

import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/model.dart';

import 'file_downloader.dart';

abstract class CreativeDownloader {
  /// Schedule to download
  download(Creative creative);

  /// Allow cancel a downloading.
  cancelDownload(Creative creative);

  /// Creative has been downloaded and persisted on file storage.
  Stream<Creative> get downloaded$;
}

class ChainDownloaderImpl implements CreativeDownloader {
  final List<CreativeDownloader> _chain;

  ChainDownloaderImpl(this._chain);

  download(Creative creative) {
    // send creative to the downloaders on chain.
    // once of these would be able to download it.
    _chain.forEach((d) => d.download(creative));
  }

  cancelDownload(Creative creative) {
    // one of downloaders in chain would be able to cancel the downloading.
    _chain.forEach((d) => d.cancelDownload(creative));
  }

  Stream<Creative> get downloaded$ {
    /// merge all streams which contains the downloaded content of
    /// 1. Youtube (which emit immediately since it don't need to download)
    /// 2. File, includes Image and Html bundle.
    /// 3. Video.
    return _downloaded$ ??= StreamController<Creative>.broadcast()
        .stream
        .mergeAll(_chain.map((d) => d.downloaded$));
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
          creative.urlPath, '/image/${creative.urlPath}', creative);
    }
  }

  cancelDownload(Creative creative) {
    _downloader.unqueue(creative.filePath);
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
          creative.urlPath, '/video/${creative.urlPath}', creative);
    }
  }

  cancelDownload(Creative creative) {
    if (creative is VideoCreative) {
      _downloader.unqueue(creative.filePath);
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
          creative.urlPath, '/html/${creative.urlPath}', creative);
    }
  }

  cancelDownload(Creative creative) {
    if (creative is HtmlCreative) {
      _downloader.unqueue(creative.filePath);
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

  cancelDownload(Creative creative) {
    // do nothing.
  }

  Stream<Creative> get downloaded$ => _controller.stream;
}
