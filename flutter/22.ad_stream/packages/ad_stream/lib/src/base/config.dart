import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/gps/gps_options.dart';
import 'package:meta/meta.dart';

class Config {
  /// Indicates how long a time block take. Duration in seconds.
  final int timeBlockToSecs;

  /// User must want the ad before he/she can skip ad. Duration in seconds.
  final int defaultCanSkipAfter;

  /// Time in seconds must elapse before [GpsController] repeatedly
  /// refresh its content.
  final int defaultGpsControllerRefreshInterval;

  /// Time in seconds must elapse before [AdScheduler] repeatedly
  /// refresh its content.
  final int defaultAdSchedulerRefreshInterval;

  /// Time in seconds must elapse before [AdRepository] repeatedly
  /// refresh its content.
  final int defaultAdRepositoryRefreshInterval;

  /// Time in seconds must elapse before [AdPresenter] do health check on
  /// its content.
  final int defaultAdPresenterHealthCheckInterval;

  /// Time in seconds indicates how frequently [CameraController] captures the
  /// photo of passenger on the trip.
  final int cameraCaptureInterval;

  /// Time in seconds indicates how frequently [MicController] records the
  /// conversation of passenger on the trip.
  final int micRecordInterval;

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

  final GpsOptions defaultGpsOptions;

  Config({
    this.timeBlockToSecs = 15,
    this.defaultCanSkipAfter = 2,
    this.defaultGpsControllerRefreshInterval = 30,
    this.defaultAdSchedulerRefreshInterval = 10,
    this.defaultAdRepositoryRefreshInterval = 60,
    this.defaultAdPresenterHealthCheckInterval = 15,
    this.cameraCaptureInterval = 10,
    this.micRecordInterval = 10,
    this.creativeDownloadParallelTasks = 3,
    this.creativeDownloadTimeout = 15,
    this.videoCreativeDownloadParallelTasks = 1,
    this.videoCreativeDownloadTimeout = 240,
    @required this.defaultGpsOptions,
    @required this.defaultAd,
    @required this.creativeBaseUrl,
  });

  Config copyWith({
    int timeBlockToSecs,
    int defaultCanSkipAfter,
    int defaultGpsControllerRefreshInterval,
    int defaultAdSchedulerRefreshInterval,
    int defaultAdRepositoryRefreshInterval,
    int defaultAdPresenterHealthCheckInterval,
    int cameraCaptureInterval,
    int micRecordInterval,
    int creativeDownloadParallelTasks,
    int creativeDownloadTimeout,
    int videoCreativeDownloadParallelTasks,
    int videoCreativeDownloadTimeout,
    GpsOptions defaultGpsOptions,
    Ad defaultAd,
    String creativeBaseUrl,
  }) {
    return Config(
      timeBlockToSecs: timeBlockToSecs ?? this.timeBlockToSecs,
      defaultCanSkipAfter: defaultCanSkipAfter ?? this.defaultCanSkipAfter,
      defaultGpsControllerRefreshInterval:
          defaultGpsControllerRefreshInterval ??
              this.defaultGpsControllerRefreshInterval,
      defaultAdSchedulerRefreshInterval: defaultAdSchedulerRefreshInterval ??
          this.defaultAdSchedulerRefreshInterval,
      defaultAdRepositoryRefreshInterval: defaultAdRepositoryRefreshInterval ??
          this.defaultAdRepositoryRefreshInterval,
      defaultAdPresenterHealthCheckInterval:
          defaultAdPresenterHealthCheckInterval ??
              this.defaultAdPresenterHealthCheckInterval,
      cameraCaptureInterval:
          cameraCaptureInterval ?? this.cameraCaptureInterval,
      micRecordInterval: cameraCaptureInterval ?? this.cameraCaptureInterval,
      creativeDownloadParallelTasks:
          creativeDownloadParallelTasks ?? this.creativeDownloadParallelTasks,
      creativeDownloadTimeout:
          creativeDownloadTimeout ?? this.creativeDownloadTimeout,
      videoCreativeDownloadParallelTasks: videoCreativeDownloadParallelTasks ??
          this.videoCreativeDownloadParallelTasks,
      videoCreativeDownloadTimeout:
          videoCreativeDownloadTimeout ?? this.videoCreativeDownloadTimeout,
      defaultGpsOptions: defaultGpsOptions ?? this.defaultGpsOptions,
      defaultAd: defaultAd ?? this.defaultAd,
      creativeBaseUrl: creativeBaseUrl ?? this.creativeBaseUrl,
    );
  }
}

abstract class ConfigFactory {
  Config createConfig();
}

class ConfigFactoryImpl implements ConfigFactory {
  Config createConfig() => Config(
        defaultGpsOptions: GpsOptions(accuracy: GpsAccuracy.best),
        defaultAd: null,
        creativeBaseUrl: 'http://localhost:8080/public/creatives/',
      );
}
