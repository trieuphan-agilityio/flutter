import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/ad/ad_repository.dart';
import 'package:ad_stream/src/modules/supervisor/supervisor.dart';

const String _kAdSchedulerIdentifier = 'AD_SCHEDULER';

abstract class AdScheduler implements ManageableService {
  /// Choose one of available Ads are buffered.
  Ad getAdForDisplay();

  /// Targeting
  setGender(PassengerGender gender);
  setAgeRange(PassengerAgeRange ageRange);
  setKeywords(Keywords keywords);
  setArea(Area area);
  setCollectTargetValuesInterval(Duration duration);
}

class AdSchedulerImpl implements AdScheduler {
  final AdRepository adRepository;
  final Config config;

  Duration refreshInterval = Duration(seconds: 30);

  Ad adToDisplay;

  TargetingValues targetingValues;

  AdSchedulerImpl(this.adRepository, this.config)
      : targetingValues = TargetingValues();

  /// AdScheduler

  Ad getAdForDisplay() {
    return adToDisplay ?? config.defaultAd;
  }

  setAgeRange(PassengerAgeRange ageRange) => targetingValues.add(ageRange);
  setArea(Area area) => targetingValues.add(area);
  setGender(PassengerGender gender) => targetingValues.add(gender);
  setKeywords(Keywords keywords) => targetingValues.add(keywords);

  setCollectTargetValuesInterval(Duration duration) {
    refreshInterval = duration;
  }

  /// ManageableService

  String get identifier => _kAdSchedulerIdentifier;

  Future<void> start() {
    print('AdSchedule starting');
    return Future.sync(() => null);
  }

  Future<void> stop() {
    print('AdSchedule stopping');
    return Future.sync(() => null);
  }
}
