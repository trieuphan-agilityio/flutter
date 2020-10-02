import 'package:ad_bloc/config.dart';
import 'package:ad_bloc/model.dart';
import 'package:meta/meta.dart';

import 'camera_config.dart';
import 'downloader_config.dart';

class Config {
  /// Indicates how long a time block take. Duration in seconds.
  final int timeBlockToSecs;

  /// User must want the ad before he/she can skip ad. Duration in seconds.
  final int defaultCanSkipAfter;

  /// Ad that should be displayed when the app is fetching from Ad Server.
  final Ad defaultAd;

  /// Whether default Ad from config is enabled. Sometime it prefers to get
  /// default ad via Ad Server instead of remote config.
  final bool defaultAdEnabled;

  /// Base URL that is used for constructing Creative download URL.
  /// e.g: https://s3.awscloud.com/stag/creative/
  final String creativeBaseUrl;

  /// Time in seconds must elapse before [GpsController] repeatedly
  /// refresh its content.
  final int defaultGpsControllerRefreshInterval;

  /// Desired accuracy that uses to determine the gps data.
  final int gpsAccuracy;

  /// The minimum distance (measured in meters) a device must move before
  /// an update event is generated.
  final int gpsDistanceFilter;

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

  /// Time in seconds must elapse before [AreaDetector] updating with latest
  /// [LatLng] value.
  final int areaRefreshInterval;

  /// Number of downloading tasks are executed in parallel.
  final int creativeDownloadParallelTasks;

  /// Timeout in seconds for downloading a non-video creative.
  final int creativeDownloadTimeout;

  /// Number of downloading video tasks are executed in parallel.
  final int videoCreativeDownloadParallelTasks;

  /// Timeout in seconds for downloading a video creative.
  final int videoCreativeDownloadTimeout;

  Config({
    this.timeBlockToSecs = 15,
    this.defaultCanSkipAfter = 2,
    this.defaultGpsControllerRefreshInterval = 30,
    this.gpsAccuracy = 2,
    this.gpsDistanceFilter,
    this.defaultAdSchedulerRefreshInterval = 10,
    this.defaultAdRepositoryRefreshInterval = 60,
    this.defaultAdPresenterHealthCheckInterval = 15,
    this.cameraCaptureInterval = 10,
    this.micRecordInterval = 10,
    this.areaRefreshInterval = 30,
    this.creativeDownloadParallelTasks = 2,
    this.creativeDownloadTimeout = 5,
    this.videoCreativeDownloadParallelTasks = 2,
    this.videoCreativeDownloadTimeout = 240,
    @required this.defaultAd,
    @required this.defaultAdEnabled,
    @required this.creativeBaseUrl,
  });

  Config copyWith({
    int timeBlockToSecs,
    int defaultCanSkipAfter,
    int defaultGpsControllerRefreshInterval,
    int gpsAccuracy,
    int gpsDistanceFilter,
    int defaultAdSchedulerRefreshInterval,
    int defaultAdRepositoryRefreshInterval,
    int defaultAdPresenterHealthCheckInterval,
    int cameraCaptureInterval,
    int micRecordInterval,
    int areaRefreshInterval,
    int creativeDownloadParallelTasks,
    int creativeDownloadTimeout,
    int videoCreativeDownloadParallelTasks,
    int videoCreativeDownloadTimeout,
    GpsOptions defaultGpsOptions,
    Ad defaultAd,
    bool defaultAdEnabled,
    String creativeBaseUrl,
  }) {
    return Config(
      timeBlockToSecs: timeBlockToSecs ?? this.timeBlockToSecs,
      defaultCanSkipAfter: defaultCanSkipAfter ?? this.defaultCanSkipAfter,
      defaultGpsControllerRefreshInterval:
          defaultGpsControllerRefreshInterval ??
              this.defaultGpsControllerRefreshInterval,
      gpsAccuracy: gpsAccuracy ?? this.gpsAccuracy,
      gpsDistanceFilter: gpsDistanceFilter ?? this.gpsDistanceFilter,
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
      areaRefreshInterval: areaRefreshInterval ?? this.areaRefreshInterval,
      creativeDownloadParallelTasks:
          creativeDownloadParallelTasks ?? this.creativeDownloadParallelTasks,
      creativeDownloadTimeout:
          creativeDownloadTimeout ?? this.creativeDownloadTimeout,
      videoCreativeDownloadParallelTasks: videoCreativeDownloadParallelTasks ??
          this.videoCreativeDownloadParallelTasks,
      videoCreativeDownloadTimeout:
          videoCreativeDownloadTimeout ?? this.videoCreativeDownloadTimeout,
      defaultAd: defaultAd ?? this.defaultAd,
      defaultAdEnabled: defaultAdEnabled ?? this.defaultAdEnabled,
      creativeBaseUrl: creativeBaseUrl ?? this.creativeBaseUrl,
    );
  }

  AdConfig toAdConfig() {
    return AdConfig(
      timeBlockToSecs: timeBlockToSecs,
      defaultCanSkipAfter: defaultCanSkipAfter,
      creativeBaseUrl: creativeBaseUrl,
      defaultAd: defaultAd,
      defaultAdEnabled: defaultAdEnabled,
    );
  }

  AdRepositoryConfig toAdRepositoryConfig() {
    return AdRepositoryConfig(
      refreshInterval: defaultAdRepositoryRefreshInterval,
    );
  }

  CameraConfig toCameraConfig() {
    return CameraConfig(captureInterval: cameraCaptureInterval);
  }

  DownloaderConfig toDownloaderConfig() {
    return DownloaderConfig(
      creativeDownloadTimeout: creativeDownloadTimeout,
      creativeDownloadParallelTasks: creativeDownloadParallelTasks,
      videoCreativeDownloadTimeout: videoCreativeDownloadTimeout,
      videoCreativeDownloadParallelTasks: videoCreativeDownloadParallelTasks,
    );
  }
}
