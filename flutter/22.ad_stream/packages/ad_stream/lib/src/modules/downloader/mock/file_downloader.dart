import 'dart:async';
import 'dart:math';

import 'package:ad_stream/src/modules/downloader/downloaded_file.dart';
import 'package:ad_stream/src/modules/downloader/file_downloader.dart';

class MockFileDownloader implements FileDownloader {
  final StreamController<DownloadedFile> _controller;

  MockFileDownloader()
      : _controller = StreamController<DownloadedFile>.broadcast();

  Stream<DownloadedFile> get file$ => _controller.stream;

  enqueue(String fileUrl, String saveToPath, Object metadata) {
    // simulate downloading delay 300ms - 5s.
    Timer(Duration(milliseconds: _random.nextInt(4700) + 300), () {
      _controller.add(DownloadedFile(
        fileUrl: fileUrl,
        filePath: fileUrl,
        metadata: metadata,
        createdAt: DateTime.now(),
      ));
    });
  }

  unqueue(String filePath) {
    /// do nothing.
  }

  Random _random = Random();
}
