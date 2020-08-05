import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/features/ad_displaying/ad_presenter.dart';
import 'package:ad_stream/src/modules/ad/ad_repository.dart';
import 'package:ad_stream/src/modules/ad/ad_scheduler.dart';
import 'package:inject/inject.dart';

/// Declare public interface that an AdService should expose
abstract class AdServiceLocator {
  @provide
  ConfigFactory get configFactory;

  @provide
  AdPresentable get adPresenter;

  @provide
  AdScheduler get adScheduler;

  @provide
  AdRepository get adRepository;
}

@module
class AdServices {
  @provide
  @singleton
  ConfigFactory configFactory() {
    return ConfigFactoryImpl();
  }

  @provide
  @singleton
  AdPresentable adPresenter(AdScheduler adScheduler) {
    return AdPresenter(adScheduler);
  }

  @provide
  @singleton
  AdScheduler adScheduler(AdRepository adRepository) {
    return AdSchedulerImpl(adRepository);
  }

  @provide
  @singleton
  AdRepository adRepository() {
    return AdRepositoryImpl();
  }
}
