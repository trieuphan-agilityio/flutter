import 'package:meta/meta.dart';

class AdSchedulerConfig {
  /// Time in seconds must elapse before [AdScheduler] repeatedly
  /// refresh its content.
  final int refreshInterval;

  AdSchedulerConfig({@required this.refreshInterval});
}

abstract class AdSchedulerConfigProvider {
  AdSchedulerConfig get adSchedulerConfig;
  Stream<AdSchedulerConfig> get adSchedulerConfig$;
}
