import 'package:meta/meta.dart';

class DownloaderConfig {
  /// Number of downloading tasks are executed in parallel.
  final int creativeDownloadParallelTasks;

  /// Timeout in seconds for downloading a non-video creative.
  final int creativeDownloadTimeout;

  /// Number of downloading video tasks are executed in parallel.
  final int videoCreativeDownloadParallelTasks;

  /// Timeout in seconds for downloading a video creative.
  final int videoCreativeDownloadTimeout;

  DownloaderConfig({
    @required this.creativeDownloadParallelTasks,
    @required this.creativeDownloadTimeout,
    @required this.videoCreativeDownloadParallelTasks,
    @required this.videoCreativeDownloadTimeout,
  });
}

abstract class DownloaderConfigProvider {
  DownloaderConfig get downloaderConfig;
  Stream<DownloaderConfig> get downloaderConfig$;
}
