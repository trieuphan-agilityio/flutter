import 'package:ad_stream/src/models/targeting_value.dart';
import 'package:ad_stream/src/modules/ad/ad_repository.dart';

import '../../models/ad.dart';

abstract class AdScheduler {
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

  final TargetingValues targetingValues;

  Duration refreshInterval = Duration(seconds: 30);

  AdSchedulerImpl(this.adRepository) : targetingValues = TargetingValues();

  Ad getAdForDisplay() {
    return null;
  }

  setAgeRange(PassengerAgeRange ageRange) => targetingValues.add(ageRange);
  setArea(Area area) => targetingValues.add(area);
  setGender(PassengerGender gender) => targetingValues.add(gender);
  setKeywords(Keywords keywords) => targetingValues.add(keywords);

  setCollectTargetValuesInterval(Duration duration) {
    refreshInterval = duration;
  }
}
