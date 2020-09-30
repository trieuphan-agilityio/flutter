import 'dart:async';
import 'dart:io';

import 'package:ad_bloc/src/service/file_downloader.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeFilePathResolver implements FilePathResolver {
  @override
  FutureOr<String> resolve(String filePath) {
    return '${Directory.systemTemp.path}/$filePath';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  FileDownloaderImpl fileDownloader;
  FileUrlResolverImpl fileUrlResolver;
  FakeFilePathResolver filePathResolver;

  Object metadata;
  List<DownloadedFile> downloaded;
  List<String> errors;
  bool isDone;

  group('FileDownloaderImpl', () {
    setUp(() {
      fileUrlResolver = FileUrlResolverImpl();
      filePathResolver = FakeFilePathResolver();

      fileDownloader = FileDownloaderImpl(
        fileUrlResolver: fileUrlResolver,
        filePathResolver: filePathResolver,
      );
      metadata = Object();
      downloaded = [];
      errors = [];
      isDone = false;

      fileDownloader.file$.listen(
        downloaded.add,
        onError: errors.add,
        onDone: () => isDone = true,
      );
    });

    test('can download', () async {
      fileDownloader.enqueue('p0.jpg', 'image/p0.jpg', metadata);

      await Future.delayed(Duration(seconds: 1));

      final expectedFileUrl = fileUrlResolver.resolve('p0.jpg');
      final expectedFilePath = filePathResolver.resolve('image/p0.jpg');

      expect(downloaded.length, 1);
      expect(downloaded[0].fileUrl, expectedFileUrl);
      expect(downloaded[0].filePath, expectedFilePath);
      expect(downloaded[0].metadata, metadata);
      expect(errors, []);
      expect(isDone, false);
    });
  });
}
