import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/features/ad_displaying/ad_presenter.dart';
import 'package:ad_stream/src/modules/ad/ad_api_client.dart';
import 'package:ad_stream/src/modules/ad/ad_database.dart';
import 'package:ad_stream/src/modules/ad/ad_repository.dart';
import 'package:ad_stream/src/modules/ad/ad_scheduler.dart';
import 'package:ad_stream/src/modules/ad/creative_downloader.dart';
import 'package:ad_stream/src/modules/ad/mock/ad_api_client.dart';
import 'package:ad_stream/src/modules/ad/mock/ad_database.dart';
import 'package:ad_stream/src/modules/common/file_path_resolver.dart';
import 'package:ad_stream/src/modules/common/file_url_resolver.dart';
import 'package:ad_stream/src/modules/downloader/download_options.dart';
import 'package:ad_stream/src/modules/downloader/file_downloader.dart';
import 'package:ad_stream/src/modules/gps/gps_controller.dart';
import 'package:ad_stream/src/modules/service_manager/service_manager.dart';

/// Declare public interface that an AdModule should expose
abstract class AdModuleLocator {
  @provide
  Config get config;

  @provide
  AdPresenter get adPresenter;

  @provide
  AdScheduler get adScheduler;

  @provide
  AdRepository get adRepository;

  @provide
  CreativeDownloader get creativeDownloader;
}

/// A source of dependency provider for the injector.
/// It contains Ad related services.
@module
class AdModule {
  @provide
  @singleton
  ConfigFactory configFactory() {
    return ConfigFactoryImpl();
  }

  @provide
  @singleton
  Config config(ConfigFactory factory) {
    return factory.createConfig();
  }

  @provide
  @singleton
  AdPresenter adPresenter(AdScheduler adScheduler) {
    return AdPresenterImpl(adScheduler);
  }

  @provide
  @singleton
  AdScheduler adScheduler(
    ServiceManager serviceManager,
    AdRepository adRepository,
    Config config,
  ) {
    final adScheduler = AdSchedulerImpl(adRepository, config);
    adScheduler.listen(serviceManager.status$);
    return adScheduler;
  }

  @provide
  @singleton
  AdRepository adRepository(
    AdApiClient adApiClient,
    AdDatabase adDatabase,
    CreativeDownloader creativeDownloader,
    Config config,
    ServiceManager serviceManager,
    GpsController gpsController,
  ) {
    final adRepository = AdRepositoryImpl(
      adApiClient,
      adDatabase,
      creativeDownloader,
      config,
    );
    adRepository.keepWatching(gpsController.latLng$);
    adRepository.listen(serviceManager.status$);
    return adRepository;
  }

  @provide
  @singleton
  CreativeDownloader creativeDownloader(
    FileUrlResolver fileUrlResolver,
    FilePathResolver filePathResolver,
    Config config,
  ) {
    final image = ImageCreativeDownloader(FileDownloaderImpl(
        fileUrlResolver: fileUrlResolver,
        options: DownloadOptions(
            numOfParallelTasks: config.creativeDownloadParallelTasks,
            timeoutSecs: config.creativeDownloadTimeout)));

    final video = VideoCreativeDownloader(FileDownloaderImpl(
        fileUrlResolver: fileUrlResolver,
        options: DownloadOptions(
            numOfParallelTasks: config.videoCreativeDownloadParallelTasks,
            timeoutSecs: config.videoCreativeDownloadTimeout)));

    final html = HtmlCreativeDownloader(FileDownloaderImpl(
        fileUrlResolver: fileUrlResolver,
        options: DownloadOptions(
            numOfParallelTasks: config.creativeDownloadParallelTasks,
            timeoutSecs: config.creativeDownloadTimeout)));

    final youtube = YoutubeCreativeDownloader();

    return ChainDownloaderImpl([image, video, html, youtube]);
  }

  @provide
  @singleton
  AdApiClient adApiClient() {
    return MockAdApiClient();
  }

  @provide
  @singleton
  AdDatabase adDatabase() {
    return MockAdDatabase();
  }
}
