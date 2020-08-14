import 'dart:async';
import 'dart:math';

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
  setAreas(List<Area> area);
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

  setAreas(List<Area> areas) => targetingValues.addAll(areas);

  setGender(PassengerGender gender) => targetingValues.add(gender);

  setKeywords(List<Keyword> keywords) => targetingValues.addAll(keywords);

  /// TaskService

  /// Default time in seconds that must elapse before [AdScheduler] starts
  /// collecting Targeting Values and filter the latest [Ad] from AdRepository.
  int get defaultRefreshInterval => _config.defaultAdSchedulerRefreshInterval;

  @override
  Future<void> start() {
    super.start();
    Log.info('AdScheduler started.');
    return null;
  }

  @override
  Future<void> stop() {
    super.stop();
    Log.info('AdScheduler stopped.');
    return null;
  }

  Future<void> runTask() async {
    /// going to pick an Ad from the "ready" stream Ads.
    final readyAds = await _adRepository.getReadyList(targetingValues);

    if (readyAds.length == 0) {
      // unload if there is no candidate
      _adToDisplay = null;
      Log.info('AdScheduler beating');
      return null;
    }

    // FIXME It supposes to figure out which ad is best for displaying.
    final pickedAd = readyAds[_random.nextInt(readyAds.length - 1)];

    if (_adToDisplay == pickedAd) {
      Log.info('AdScheduler beating');
      return null;
    }

    // schedule an Ad for displaying
    _adToDisplay = pickedAd;

    Log.info('AdScheduler picked Ad{id: ${_adToDisplay.shortId}'
        ', creativeId: ${_adToDisplay.creative.shortId}'
        ', version: ${_adToDisplay.version}}');

    return null;
  }

  Random _random = Random();
}
