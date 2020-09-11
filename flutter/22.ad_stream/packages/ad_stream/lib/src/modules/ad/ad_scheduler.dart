import 'dart:async';
import 'dart:math';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/config.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/base/service.dart';

abstract class AdScheduler {
  /// Ad that is ready for displaying.
  Ad get adForDisplay;
}

class AdSchedulerImpl with ServiceMixin implements AdScheduler, Service {
  AdSchedulerImpl(
    this.ads$,
    this.targetingValues$,
    this.adSchedulerConfigProvider,
    this.adConfigProvider,
  ) {
    backgroundTask = ServiceTask(
      _pickAd,
      adSchedulerConfigProvider.adSchedulerConfig.refreshInterval,
    );

    adSchedulerConfigProvider.adSchedulerConfig$.listen((config) {
      backgroundTask?.refreshIntervalSecs = config.refreshInterval;
    });
  }

  /// Ads that are available for displaying if they match targeting values from
  /// [targetinValues$]
  final Stream<List<Ad>> ads$;

  /// Collect a set of targeting value that helps narrows who sees ads and helps
  /// advertisers reach an intended audience with their campaigns.
  final Stream<TargetingValues> targetingValues$;

  /// AdScheduler

  /// Ad that matched targeting values and is placed here to wait for displaying.
  Ad get adForDisplay => _pickedAd ?? adConfigProvider.adConfig.defaultAd;

  /// Service

  @override
  start() async {
    super.start();

    disposer.autoDispose(ads$.listen((newValue) {
      ads = newValue;
      _pickAd();
    }));

    disposer.autoDispose(targetingValues$.listen((newValue) {
      targetingValues = newValue;
      _pickAd();
    }));
  }

  _pickAd() async {
    final matchedAds = ads.where((ad) => ad.isMatch(targetingValues)).toList();

    if (matchedAds.length == 0) {
      // unload if there is no candidate
      _pickedAd = null;
      Log.debug('AdScheduler beating');
      return null;
    }

    Ad pickedAd;

    if (matchedAds.length == 1) {
      pickedAd = matchedAds.first;
    } else {
      // FIXME It supposes to figure out which ad is best for displaying.
      pickedAd = matchedAds.elementAt(_random.nextInt(matchedAds.length - 1));
    }

    if (_pickedAd == pickedAd) {
      Log.debug('AdScheduler beating');
      return null;
    }

    // choose this Ad for displaying
    _pickedAd = pickedAd;

    Log.info('AdScheduler picked Ad{id: ${_pickedAd.shortId}'
        ', creativeId: ${_pickedAd.creative.shortId}'
        ', version: ${_pickedAd.version}}'
        '${targetingValues == null ? "." : ", with _targetingValues."}');
  }

  /// Current collected targeting values that are observed from [targetingValues$].
  TargetingValues targetingValues = TargetingValues();

  /// Current ads that has creatives were downloaded
  List<Ad> ads = [];

  final AdSchedulerConfigProvider adSchedulerConfigProvider;
  final AdConfigProvider adConfigProvider;

  /// backing field of [adForDisplay]
  Ad _pickedAd;

  final Random _random = Random();
}
