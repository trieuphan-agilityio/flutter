import 'package:ad_stream/models.dart';

class Config {
  /// Indicates how long a time block take. Duration in seconds.
  final int timeBlockToSeconds;

  /// User must want the ad before he/she can skip ad. Duration in seconds.
  final int defaultCanSkipAfter;

  /// Ad that should be displayed when the app is fetching from Ad Server.
  final Ad defaultAd;

  ///

  Config({
    this.timeBlockToSeconds = 15,
    this.defaultCanSkipAfter = 6,
    this.defaultAd,
  });
}

abstract class ConfigFactory {
  Config createConfig();
}

class ConfigFactoryImpl implements ConfigFactory {
  Config createConfig() => Config();
}
