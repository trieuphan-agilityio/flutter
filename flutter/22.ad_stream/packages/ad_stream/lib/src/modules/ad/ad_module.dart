import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/features/ad_displaying/ad_presenter.dart';
import 'package:ad_stream/src/modules/ad/ad_repository.dart';
import 'package:ad_stream/src/modules/ad/ad_scheduler.dart';

/// Declare public interface that an AdModule should expose
abstract class AdModuleLocator {
  @provide
  AdPresentable get adPresenter;

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
  AdPresentable adPresenter(AdScheduler adScheduler) {
    return AdPresenter(adScheduler);
  }

  @provide
  @singleton
  AdScheduler adScheduler(AdRepository adRepository, Config config) {
    return AdSchedulerImpl(adRepository, config);
  }

  @provide
  @singleton
  AdRepository adRepository() {
    return AdRepositoryImpl();
  }
}
