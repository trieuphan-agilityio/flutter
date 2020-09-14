class AdSchedulerConfig {
  AdSchedulerConfig();
}

abstract class AdSchedulerConfigProvider {
  AdSchedulerConfig get adSchedulerConfig;
  Stream<AdSchedulerConfig> get adSchedulerConfig$;
}
