import 'package:ad_stream/src/modules/downloader/downloaded_file.dart';
import 'package:ad_stream/src/modules/downloader/file_downloader.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  FileDownloaderImpl fileDownloader;

  List<DownloadedFile> emittedValues;
  List<String> errors;
  bool isDone;
  Object metadata;

  group('FileDownloaderImpl', () {
    setUp(() {
      fileDownloader = FileDownloaderImpl();
      emittedValues = [];
      errors = [];
      isDone = false;
      metadata = Object();

      fileDownloader.file$.listen(emittedValues.add,
          onError: errors.add, onDone: () => isDone = true);
    });
    test('can download file', () {
      fileDownloader.enqueue(
        'https://lorem-picsum.s3-ap-southeast-1.amazonaws.com/ad-stream/p3.jpg',
        'p3.jpg',
        metadata,
      );
    });
  });
}
