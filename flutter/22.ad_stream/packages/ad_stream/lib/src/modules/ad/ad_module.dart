import 'package:ad_stream/base.dart';
import 'package:ad_stream/config.dart';
import 'package:ad_stream/src/modules/ad/ad_api_client.dart';
import 'package:ad_stream/src/modules/ad/ad_presenter.dart';
import 'package:ad_stream/src/modules/ad/ad_repository.dart';
import 'package:ad_stream/src/modules/ad/ad_scheduler.dart';
import 'package:ad_stream/src/modules/ad/creative_downloader.dart';
import 'package:ad_stream/src/modules/ad/mock/ad_api_client.dart';
import 'package:ad_stream/src/modules/common/file_path_resolver.dart';
import 'package:ad_stream/src/modules/common/file_url_resolver.dart';
import 'package:ad_stream/src/modules/downloader/mock/file_downloader.dart';
import 'package:ad_stream/src/modules/gps/gps_controller.dart';
import 'package:ad_stream/src/modules/on_trip/age_detector.dart';
import 'package:ad_stream/src/modules/on_trip/area_detector.dart';
import 'package:ad_stream/src/modules/on_trip/gender_detector.dart';
import 'package:ad_stream/src/modules/on_trip/keyword_detector.dart';
import 'package:ad_stream/src/modules/on_trip/trip_detector.dart';
import 'package:ad_stream/src/modules/service_manager/service_manager.dart';

import 'debugger/ad_repository_debugger.dart';
import 'targeting_value_collector.dart';

/// Declare public interface that an AdModule should expose
abstract class AdModuleLocator {
  @provide
  AdPresenterConfigProvider get config;

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
  @asynchronous
  Future<Config> config(ConfigFactory configFactory) {
    return configFactory.createConfig();
  }

  @provide
  @singleton
  AdPresenter adPresenter(
    ServiceManager serviceManager,
    AdScheduler adScheduler,
    AdPresenterConfigProvider adPresenterConfigProvider,
    AdConfigProvider adConfigProvider,
  ) {
    final adPresenter = AdPresenterImpl(
      adScheduler,
      adPresenterConfigProvider,
      adConfigProvider,
    );
    adPresenter.listenTo(serviceManager.status$);
    return adPresenter;
  }

  @provide
  @singleton
  TargetingValueCollector targetingValueCollector(
    ServiceManager serviceManager,
    GenderDetector genderDetector,
    AgeDetector ageDetector,
    TripDetector tripDetector,
    KeywordDetector keywordDetector,
    AreaDetector areaDetector,
  ) {
    final targetingValueCollector = TargetingValueCollectorImpl(
      genderDetector,
      ageDetector,
      tripDetector.state$,
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
    AdSchedulerConfigProvider adSchedulerConfigProvider,
    AdConfigProvider adConfigProvider,
    TargetingValueCollector targetingValueCollector,
  ) {
    final adScheduler = AdSchedulerImpl(
      adRepository.ads$,
      targetingValueCollector.targetingValues$,
      adSchedulerConfigProvider,
      adConfigProvider,
    );
    adScheduler.listenTo(serviceManager.status$);
    return adScheduler;
  }

  @provide
  @singleton
  AdRepositoryDebugger adRepositoryDebugger() {
    return AdRepositoryDebuggerImpl();
  }

  @provide
  @singleton
  AdRepository adRepository(
    AdApiClient adApiClient,
    CreativeDownloader creativeDownloader,
    AdRepositoryConfigProvider configProvider,
    ServiceManager serviceManager,
    GpsController gpsController,
    AdRepositoryDebugger adRepositoryDebugger,
  ) {
    final adRepository = AdRepositoryImpl(
      adApiClient,
      creativeDownloader,
      configProvider,
      debugger: adRepositoryDebugger,
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
