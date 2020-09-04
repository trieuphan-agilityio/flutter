import 'package:ad_stream/base.dart';
import 'file_path_resolver.dart';
import 'file_url_resolver.dart';

/// Declare public interface that an CommonModule should expose
abstract class CommonModuleLocator {
  @provide
  FileUrlResolver get fileUrlResolver;

  @provide
  FilePathResolver get filePathResolver;
}

/// A source of dependency provider for the injector.
/// It contains Common services.
@module
class CommonModule {
  @provide
  @singleton
  FileUrlResolver fileUrlResolver() {
    return FileUrlResolverImpl();
  }

  @provide
  @singleton
  FilePathResolver filePathResolver() {
    return FilePathResolverImpl();
  }
}
