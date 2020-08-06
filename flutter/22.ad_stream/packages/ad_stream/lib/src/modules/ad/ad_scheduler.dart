import 'dart:async';

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

  /// Amount of time that must elapse before AdSchedule can refresh its content.
  Duration refreshInterval;

  /// Ad that matched targeting values and place here to wait for displaying.
  Ad _adToDisplay;

  /// A set of targeting value that helps narrows who sees ads and helps
  /// advertisers reach an intended audience with their campaigns.
  TargetingValues targetingValues;

  AdSchedulerImpl(this.adRepository, this.config)
      : targetingValues = TargetingValues(),
        refreshInterval =
            Duration(seconds: config.defaultAdSchedulerRefreshInterval);

  /// AdScheduler

  Ad getAdForDisplay() {
    return _adToDisplay ?? config.defaultAd;
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
    Log.info('AdSchedule is starting');
    return null;
  }

  Future<void> stop() {
    Log.info('AdSchedule is stopping');
    return null;
  }

  Timer timer;
}
