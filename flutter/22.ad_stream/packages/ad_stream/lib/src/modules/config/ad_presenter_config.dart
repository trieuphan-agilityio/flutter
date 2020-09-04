import 'package:meta/meta.dart';

class AdPresenterConfig {
  /// Time in seconds must elapse before [AdPresenter] do health check on
  /// its content.
  final int healthCheckInterval;

  AdPresenterConfig({@required this.healthCheckInterval});
}

abstract class AdPresenterConfigProvider {
  AdPresenterConfig get adPresenterConfig;
  Stream<AdPresenterConfig> get adPresenterConfig$;
}
