import 'package:rxdart/subjects.dart';
import 'package:ad_stream/config.dart';

abstract class ConfigProvider
    implements
        AdConfigProvider,
        AdPresenterConfigProvider,
        AdRepositoryConfigProvider,
        AdSchedulerConfigProvider,
        AreaConfigProvider,
        CameraConfigProvider,
        DownloaderConfigProvider,
        GpsConfigProvider,
        MicConfigProvider {
  /// the current config
  Config get config;

  /// change config
  set config(Config newValue);

  /// config as stream
  Stream<Config> get config$;
}

class ConfigProviderImpl implements ConfigProvider {
  // ignore: close_sinks
  final configSubject = BehaviorSubject<Config>();

  Config get config => configSubject.value;

  set config(Config newValue) => configSubject.add(newValue);

  Stream<Config> get config$ => configSubject;

  /// AdConfigProvider

  AdConfig get adConfig => configSubject.value.toAdConfig();

  Stream<AdConfig> get adConfig$ =>
      config$.map((c) => c.toAdConfig()).distinct();

  /// AdPresenterConfigProvider

  AdPresenterConfig get adPresenterConfig {
    return configSubject.value.toAdPresenterConfig();
  }

  Stream<AdPresenterConfig> get adPresenterConfig$ {
    return config$.map((c) => c.toAdPresenterConfig()).distinct();
  }

  /// AdRepositoryConfigProvider

  AdRepositoryConfig get adRepositoryConfig {
    return configSubject.value.toAdRepositoryConfig();
  }

  Stream<AdRepositoryConfig> get adRepositoryConfig$ {
    return config$.map((c) => c.toAdRepositoryConfig()).distinct();
  }

  /// AdSchedulerConfigProvider

  AdSchedulerConfig get adSchedulerConfig {
    return configSubject.value.toAdSchedulerConfig();
  }

  Stream<AdSchedulerConfig> get adSchedulerConfig$ {
    return config$.map((c) => c.toAdSchedulerConfig()).distinct();
  }

  /// AreaConfigProvider

  AreaConfig get areaConfig => configSubject.value.toAreaConfig();

  Stream<AreaConfig> get areaConfig$ =>
      config$.map((c) => c.toAreaConfig()).distinct();

  /// CameraConfigProvider

  CameraConfig get cameraConfig {
    return configSubject.value.toCameraConfig();
  }

  Stream<CameraConfig> get cameraConfig$ {
    return config$.map((c) => c.toCameraConfig()).distinct();
  }

  /// DownloaderConfigProvider

  DownloaderConfig get downloaderConfig {
    return configSubject.value.toDownloaderConfig();
  }

  Stream<DownloaderConfig> get downloaderConfig$ {
    return config$.map((c) => c.toDownloaderConfig()).distinct();
  }

  /// GpsConfigProvider

  GpsConfig get gpsConfig => configSubject.value.toGpsConfig();

  Stream<GpsConfig> get gpsConfig$ =>
      config$.map((c) => c.toGpsConfig()).distinct();

  /// MicConfigProvider

  MicConfig get micConfig => configSubject.value.toMicConfig();

  Stream<MicConfig> get micConfig$ =>
      config$.map((c) => c.toMicConfig()).distinct();
}
