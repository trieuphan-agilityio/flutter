import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/ad/ad_repository.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';

abstract class AdScheduler {
  /// Choose one of available Ads are buffered.
  Ad getAdForDisplay();

  /// Targeting
  setGender(PassengerGender gender);
  setAgeRange(PassengerAgeRange ageRange);
  setKeywords(List<Keyword> keywords);
  setArea(Area area);
}

class AdSchedulerImpl extends TaskService
    with ServiceMixin, TaskServiceMixin
    implements AdScheduler {
  final AdRepository _adRepository;
  final Config _config;

  /// Ad that matched targeting values and place here to wait for displaying.
  Ad _adToDisplay;

  /// A set of targeting value that helps narrows who sees ads and helps
  /// advertisers reach an intended audience with their campaigns.
  TargetingValues targetingValues;

  AdSchedulerImpl(this._adRepository, this._config)
      : targetingValues = TargetingValues();

  /// AdScheduler

  Ad getAdForDisplay() {
    return _adToDisplay ?? _config.defaultAd;
  }

  setAgeRange(PassengerAgeRange ageRange) => targetingValues.add(ageRange);

  setArea(Area area) => targetingValues.add(area);

  setGender(PassengerGender gender) => targetingValues.add(gender);

  setKeywords(List<Keyword> keywords) => keywords.forEach(targetingValues.add);

  /// TaskService

  /// Default time in seconds that must elapse before [AdScheduler] starts
  /// collecting Targeting Values and filter the latest [Ad] from AdRepository.
  int get defaultRefreshInterval => _config.defaultAdSchedulerRefreshInterval;

  Future<void> start() {
    super.start();
    Log.info('AdScheduler is starting');
    return null;
  }

  Future<void> stop() {
    super.stop();
    Log.info('AdScheduler is stopping');
    return null;
  }

  Future<void> runTask() {
    Log.info('AdScheduler is preparing Ads for displaying');
    return null;
  }
}
