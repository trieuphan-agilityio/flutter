import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/features/ad_displaying/ad_presenter.dart';
import 'package:ad_stream/src/modules/ad/ad_repository.dart';
import 'package:ad_stream/src/modules/ad/ad_scheduler.dart';
import 'package:ad_stream/src/modules/service_manager/service_manager.dart';

/// Declare public interface that an AdModule should expose
abstract class AdModuleLocator {
  @provide
  AdPresenter get adPresenter;

  @provide
  AdScheduler get adScheduler;

  @provide
  AdRepository get adRepository;

  @provide
  Config get config;
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
  AdRepository adRepository(ServiceManager serviceManager) {
    final adRepository = AdRepositoryImpl();
    adRepository.listen(serviceManager.status$);
    return adRepository;
  }
}
