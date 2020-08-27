import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/ad/ad_api_client.dart';
import 'package:ad_stream/src/modules/ad/ad_presenter.dart';
import 'package:ad_stream/src/modules/ad/ad_repository.dart';
import 'package:ad_stream/src/modules/ad/ad_scheduler.dart';
import 'package:ad_stream/src/modules/ad/creative_downloader.dart';
import 'package:ad_stream/src/modules/ad/mock/ad_api_client.dart';
import 'package:ad_stream/src/modules/common/file_path_resolver.dart';
import 'package:ad_stream/src/modules/common/file_url_resolver.dart';
import 'package:ad_stream/src/modules/downloader/download_options.dart';
import 'package:ad_stream/src/modules/downloader/file_downloader.dart';
import 'package:ad_stream/src/modules/downloader/mock/file_downloader.dart';
import 'package:ad_stream/src/modules/gps/gps_controller.dart';
import 'package:ad_stream/src/modules/on_trip/age_detector.dart';
import 'package:ad_stream/src/modules/on_trip/area_detector.dart';
import 'package:ad_stream/src/modules/on_trip/gender_detector.dart';
import 'package:ad_stream/src/modules/on_trip/keyword_detector.dart';
import 'package:ad_stream/src/modules/on_trip/trip_detector.dart';
import 'package:ad_stream/src/modules/service_manager/service_manager.dart';

import 'targeting_value_collector.dart';

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
  Config config(ConfigFactory configFactory) {
    return configFactory.createConfig();
  }

  @provide
  @singleton
  AdPresenter adPresenter(
    ServiceManager serviceManager,
    AdScheduler adScheduler,
    Config config,
  ) {
    final adPresenter = AdPresenterImpl(adScheduler, config);
    adPresenter.listenTo(serviceManager.status$);
    return adPresenter;
  }

  @provide
  @singleton
  TargetingValueCollector targetingValueCollector(
    ServiceManager serviceManager,
    TripDetector tripDetector,
    GenderDetector genderDetector,
    AgeDetector ageDetector,
    KeywordDetector keywordDetector,
    AreaDetector areaDetector,
  ) {
    final targetingValueCollector = TargetingValueCollectorImpl(
      tripDetector.state$,
      genderDetector.gender$,
      ageDetector.ageRange$,
      keywordDetector.keywords$,
      areaDetector.areas$,
    );
    targetingValueCollector.listenTo(serviceManager.status$);
    return targetingValueCollector;
  }

  @provide
  @singleton
  AdScheduler adScheduler(
    ServiceManager serviceManager,
    AdRepository adRepository,
    Config config,
    TargetingValueCollector targetingValueCollector,
  ) {
    final adScheduler = AdSchedulerImpl(
      adRepository,
      config,
      targetingValueCollector.targetingValues$,
    );
    adScheduler.listenTo(serviceManager.status$);
    return adScheduler;
  }

  @provide
  @singleton
  AdRepository adRepository(
    AdApiClient adApiClient,
    CreativeDownloader creativeDownloader,
    Config config,
    ServiceManager serviceManager,
    GpsController gpsController,
  ) {
    final adRepository = AdRepositoryImpl(
      adApiClient,
      creativeDownloader,
      config,
    );
    adRepository.keepWatching(gpsController.latLng$);
    adRepository.listenTo(serviceManager.status$);
    return adRepository;
  }

  @provide
  @singleton
  CreativeDownloader creativeDownloader(
    FileUrlResolver fileUrlResolver,
    FilePathResolver filePathResolver,
    Config config,
  ) {
    final mockFileDownloader = MockFileDownloader();

    final commonFileDownloader = FileDownloaderImpl(
        fileUrlResolver: fileUrlResolver,
        options: DownloadOptions(
            numOfParallelTasks: config.creativeDownloadParallelTasks,
            timeoutSecs: config.creativeDownloadTimeout));
    final videoFileDownloader = FileDownloaderImpl(
        fileUrlResolver: fileUrlResolver,
        options: DownloadOptions(
            numOfParallelTasks: config.videoCreativeDownloadParallelTasks,
            timeoutSecs: config.videoCreativeDownloadTimeout));

    final image = ImageCreativeDownloader(mockFileDownloader);
    final video = VideoCreativeDownloader(mockFileDownloader);
    final html = HtmlCreativeDownloader(mockFileDownloader);
    final youtube = YoutubeCreativeDownloader();

    return ChainDownloaderImpl([image, video, html, youtube]);
  }

  @provide
  @singleton
  AdApiClient adApiClient() {
    return MockAdApiClient();
  }
}
