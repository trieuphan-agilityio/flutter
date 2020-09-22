import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/config.dart';

abstract class ConfigProvider
    implements AdConfigProvider, AdRepositoryConfigProvider {
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

  /// AdRepositoryConfigProvider

  AdRepositoryConfig get adRepositoryConfig {
    return configSubject.value.toAdRepositoryConfig();
  }

  Stream<AdRepositoryConfig> get adRepositoryConfig$ {
    return config$.map((c) => c.toAdRepositoryConfig()).distinct();
  }
}
