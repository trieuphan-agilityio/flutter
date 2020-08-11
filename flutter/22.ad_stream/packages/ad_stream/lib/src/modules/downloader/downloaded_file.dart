import 'package:meta/meta.dart';

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
}
