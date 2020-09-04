import 'package:ad_stream/base.dart';
import 'package:ad_stream/config.dart';

/// Declare public interface that an ConfigModule should expose
abstract class ConfigModuleLocator {
  @provide
  ConfigProvider get configProvider;

  @provide
  AdConfigProvider get adConfigProvider;

  @provide
  AdPresenterConfigProvider get adPresenterConfigProvider;

  @provide
  AdRepositoryConfigProvider get adRepositoryConfigProvider;

  @provide
  AdSchedulerConfigProvider get adSchedulerConfigProvider;

  @provide
  AreaConfigProvider get areaConfigProvider;

  @provide
  CameraConfigProvider get cameraConfigProvider;

  @provide
  DownloaderConfigProvider get downloaderConfigProvider;

  @provide
  GpsConfigProvider get gpsConfigProvider;

  @provide
  MicConfigProvider get micConfigProvider;
}

/// A source of dependency provider for the injector.
/// It contains Common services.
@module
class ConfigModule {
  @provide
  @singleton
  ConfigProvider configProvider() {
    final configProvider = ConfigProviderImpl();

    // default config
    configProvider.config = Config(
      gpsAccuracy: 4,
      defaultAd: null,
      creativeBaseUrl: 'http://localhost:8080/public/creatives/',
    );

    return configProvider;
  }

  @provide
  @singleton
  AdConfigProvider adConfigProvider(
    ConfigProvider configProvider,
  ) =>
      configProvider;

  @provide
  @singleton
  AdPresenterConfigProvider adPresenterConfigProvider(
    ConfigProvider configProvider,
  ) =>
      configProvider;

  @provide
  @singleton
  AdRepositoryConfigProvider adRepositoryConfigProvider(
    ConfigProvider configProvider,
  ) =>
      configProvider;
  @provide
  @singleton
  AdSchedulerConfigProvider adSchedulerConfigProvider(
    ConfigProvider configProvider,
  ) =>
      configProvider;

  @provide
  @singleton
  AreaConfigProvider areaConfigProvider(
    ConfigProvider configProvider,
  ) =>
      configProvider;

  @provide
  @singleton
  CameraConfigProvider cameraConfigProvider(
    ConfigProvider configProvider,
  ) =>
      configProvider;

  @provide
  @singleton
  DownloaderConfigProvider downloaderConfigProvider(
    ConfigProvider configProvider,
  ) =>
      configProvider;

  @provide
  @singleton
  GpsConfigProvider gpsConfigProvider(
    ConfigProvider configProvider,
  ) =>
      configProvider;

  @provide
  @singleton
  MicConfigProvider micConfigProvider(
    ConfigProvider configProvider,
  ) =>
      configProvider;
}
