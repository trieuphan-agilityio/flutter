import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/downloader/file_downloader.dart';

abstract class CreativeDownloader {
  download(Creative creative);
  Stream<Creative> get downloadedCreative$;
}

class CreativeDownloaderImpl implements CreativeDownloader {
  final StreamController<Creative> _controller;
  final FileDownloader downloader;
  final FileDownloader videoDownloader;

  CreativeDownloaderImpl(
      {@required this.downloader, @required this.videoDownloader})
      : _controller = StreamController<Creative>();

  download(Creative creative) {
    if (creative is VideoCreative) {
      videoDownloader.enqueue(
        fileUrl: creative.urlPath,
        saveToPath: '/video/${creative.urlPath}',
        metadata: creative,
      );
    } else if (creative is ImageCreative) {
      downloader.enqueue(
        fileUrl: creative.urlPath,
        saveToPath: '/image/${creative.urlPath}',
        metadata: creative,
      );
    } else if (creative is HtmlCreative) {
      downloader.enqueue(
        fileUrl: creative.urlPath,
        saveToPath: '/html/${creative.urlPath}',
        metadata: creative,
      );
    } else {
      /// youtube don't need to be downloaded
      _controller.add(creative);
    }
  }

  Stream<Creative> get downloadedCreative$ {
    /// merge all streams which contains the downloaded content of
    /// 1. Youtube (which emit immediately since it don't need to download)
    /// 2. File, includes Image and Html bundle.
    /// 3. Video.
    return _controller.stream.mergeAll([
      downloader.file$.map((f) => f.metadata as Creative),
      videoDownloader.file$.map((f) => f.metadata as Creative)
    ]);
  }
}
