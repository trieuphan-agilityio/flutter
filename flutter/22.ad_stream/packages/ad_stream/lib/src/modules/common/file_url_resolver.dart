import 'package:ad_stream/base.dart';

/// [FileUrlResolver] translate a logical file url into an full url
/// with schema, host, port, path.
///
/// [FileDownloader] use this to figure out the file to download from
/// Asset Server.
abstract class FileUrlResolver {
  String resolve(String fileUrl);
}

class FileUrlResolverImpl implements FileUrlResolver {
  final Config config;

  FileUrlResolverImpl(this.config);

  @override
  String resolve(String fileUrl) {
    // TODO: implement resolve
    throw UnimplementedError();
  }
}
