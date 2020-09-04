import 'package:ad_stream/config.dart';
import 'package:ad_stream/src/modules/ad/ad_module.dart';

class MockAdModule extends AdModule {
  @override
  Future<Config> config(ConfigFactory configFactory) {
    return configFactory.createConfig().then((config) => config.copyWith(
          defaultAdPresenterHealthCheckInterval: 3,
          defaultAdRepositoryRefreshInterval: 3,
          defaultAdSchedulerRefreshInterval: 3,
          defaultGpsControllerRefreshInterval: 3,
        ));
  }
}
