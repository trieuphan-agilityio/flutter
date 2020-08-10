import 'package:ad_stream/models.dart';
import 'package:meta/meta.dart';

class Config {
  /// Indicates how long a time block take. Duration in seconds.
  final int timeBlockToSeconds;

  /// User must want the ad before he/she can skip ad. Duration in seconds.
  final int defaultCanSkipAfter;

  /// Time in seconds must elapse before [AdScheduler] repeatedly refresh its content.
  final int defaultAdSchedulerRefreshInterval;

  /// Time in seconds must elapse before [AdRepository] repeatedly refresh its content.
  final int defaultAdRepositoryRefreshInterval;

  /// Number of downloading tasks are executed in parallel.
  final int creativeDownloadParallelTasks;

  /// Timeout in seconds for downloading a non-video creative.
  final int creativeDownloadTimeout;

  /// Number of downloading video tasks are executed in parallel.
  final int videoCreativeDownloadParallelTasks;

  /// Timeout in seconds for downloading a video creative.
  final int videoCreativeDownloadTimeout;

  /// Ad that should be displayed when the app is fetching from Ad Server.
  final Ad defaultAd;

  /// Base URL that is used for constructing Creative download URL.
  /// e.g: https://s3.awscloud.com/stag/creative/
  final String creativeBaseUrl;

  Config({
    this.timeBlockToSeconds = 15,
    this.defaultCanSkipAfter = 2,
    this.defaultAdSchedulerRefreshInterval = 10,
    this.defaultAdRepositoryRefreshInterval = 30,
    this.creativeDownloadParallelTasks = 3,
    this.creativeDownloadTimeout = 15,
    this.videoCreativeDownloadParallelTasks = 1,
    this.videoCreativeDownloadTimeout = 240,
    @required this.defaultAd,
    @required this.creativeBaseUrl,
  });
}

abstract class ConfigFactory {
  Config createConfig();
}

class ConfigFactoryImpl implements ConfigFactory {
  Config createConfig() => Config(
        defaultAd: null,
        creativeBaseUrl: 'http://localhost:8080/public/creatives/',
      );
}
