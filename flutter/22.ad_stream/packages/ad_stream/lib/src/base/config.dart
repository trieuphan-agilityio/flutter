class Config {
  /// Indicates how long a time block take. Duration in seconds.
  final int timeBlockToSeconds;

  /// User must want the ad before he/she can skip ad. Duration in seconds.
  final int defaultCanSkipAfter;

  Config({
    this.defaultCanSkipAfter = 6,
    this.timeBlockToSeconds = 15,
  });
}

abstract class ConfigFactory {
  Config defaultConfig();
}

class ConfigFactoryImpl implements ConfigFactory {
  Config defaultConfig() {
    return Config();
  }
}
