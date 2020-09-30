import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/config.dart';
import 'package:ad_bloc/model.dart';
import 'package:ad_bloc/src/service/debugger_builder.dart';

import 'camera_config.dart';
import 'downloader_config.dart';

abstract class ConfigProvider
    implements
        AdConfigProvider,
        AdRepositoryConfigProvider,
        DownloaderConfigProvider {
  /// the current config
  Config get config;

  /// change config
  set config(Config newValue);

  /// config as stream
  Stream<Config> get config$;
}

class ConfigProviderImpl implements ConfigProvider {
  final ConfigDebugger _configDebugger;

  ConfigProviderImpl({ConfigDebugger debugger}) : _configDebugger = debugger {
    if (_configDebugger == null) {
      configSubject.add(Config(
        timeBlockToSecs: 15,
        defaultAd: kDefaultAd,
        gpsAccuracy: 4,
        creativeBaseUrl: 'http://localhost:8080/public/creatives/',
        defaultAdRepositoryRefreshInterval: 60,
      ));
    } else {
      configSubject.add(_configDebugger.config);
    }
  }

  // ignore: close_sinks
  final configSubject = BehaviorSubject<Config>();

  Config get config => configSubject.value;

  set config(Config newValue) => configSubject.add(newValue);

  Stream<Config> get config$ => configSubject;

  /// AdConfigProvider

  AdConfig get adConfig => configSubject.value.toAdConfig();

  Stream<AdConfig> get adConfig$ =>
      config$.map((c) => c.toAdConfig()).distinct();

  /// AdRepositoryConfigProvider

  AdRepositoryConfig get adRepositoryConfig {
    return configSubject.value.toAdRepositoryConfig();
  }

  Stream<AdRepositoryConfig> get adRepositoryConfig$ {
    return config$.map((c) => c.toAdRepositoryConfig()).distinct();
  }

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
}
