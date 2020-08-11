import 'package:ad_stream/base.dart';

/// [FilePathResolver] translates relative file path into the platform-specific
/// absolute path.
///
/// Typically the resolved file path would be in Cache directory or
/// in a Document directory.
abstract class FilePathResolver {
  String resolve(String filePath);
}

class FilePathResolverImpl implements FilePathResolver {
  final Config config;

  FilePathResolverImpl(this.config);

  @override
  String resolve(String filePath) {
    // TODO: implement resolve
    throw UnimplementedError();
  }
}
