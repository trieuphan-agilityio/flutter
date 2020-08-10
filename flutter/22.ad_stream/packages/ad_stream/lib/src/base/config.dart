import 'package:ad_stream/models.dart';

class Config {
  /// Indicates how long a time block take. Duration in seconds.
  final int timeBlockToSeconds;

  /// User must want the ad before he/she can skip ad. Duration in seconds.
  final int defaultCanSkipAfter;

  /// Ad that should be displayed when the app is fetching from Ad Server.
  final Ad defaultAd;

  /// Time in seconds must elapse before [AdScheduler] repeatedly refresh its content.

  final int defaultAdSchedulerRefreshInterval;

  /// Time in seconds must elapse before [AdRepository] repeatedly refresh its content.
  final int defaultAdRepositoryRefreshInterval;

  Config({
    this.timeBlockToSeconds = 15,
    this.defaultCanSkipAfter = 2,
    this.defaultAd,
    this.defaultAdSchedulerRefreshInterval = 10,
    this.defaultAdRepositoryRefreshInterval = 30,
  });
}

abstract class ConfigFactory {
  Config createConfig();
}

class ConfigFactoryImpl implements ConfigFactory {
  Config createConfig() => Config();
}
