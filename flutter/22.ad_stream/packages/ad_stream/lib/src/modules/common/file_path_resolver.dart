/// [FilePathResolver] translates relative file path into the platform-specific
/// absolute path.
///
/// Typically the resolved file path would be in Cache directory or
/// in a Document directory.
abstract class FilePathResolver {
  String resolve(String filePath);
}

class FilePathResolverImpl implements FilePathResolver {
  FilePathResolverImpl();

  @override
  String resolve(String filePath) {
    throw UnimplementedError();
  }
}
