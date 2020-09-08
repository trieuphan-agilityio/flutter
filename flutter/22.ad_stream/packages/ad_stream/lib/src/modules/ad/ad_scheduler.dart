import 'dart:async';
import 'dart:math';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/config.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/ad/ad_repository.dart';
import 'package:ad_stream/src/modules/base/service.dart';

abstract class AdScheduler {
  /// Ad that is ready for displaying.
  Ad get adForDisplay;
}

class AdSchedulerImpl with ServiceMixin implements AdScheduler, Service {
  final AdRepository adRepository;
  final AdSchedulerConfigProvider adSchedulerConfigProvider;
  final AdConfigProvider adConfigProvider;

  /// Collect a set of targeting value that helps narrows who sees ads and helps
  /// advertisers reach an intended audience with their campaigns.
  final Stream<TargetingValues> targetingValues$;

  AdSchedulerImpl(
    this.adRepository,
    this.adSchedulerConfigProvider,
    this.adConfigProvider,
    this.targetingValues$,
  ) {
    backgroundTask = ServiceTask(
      _pullAds,
      adSchedulerConfigProvider.adSchedulerConfig.refreshInterval,
    );

    adSchedulerConfigProvider.adSchedulerConfig$.listen((config) {
      backgroundTask?.refreshIntervalSecs = config.refreshInterval;
    });
  }

  /// Ad that matched targeting values and is placed here to wait for displaying.
  Ad _pickedAd;

  /// Current collected targeting values that are observed from [targetingValues$].
  TargetingValues targetingValues;

  /// AdScheduler

  Ad get adForDisplay => _pickedAd ?? adConfigProvider.adConfig.defaultAd;

  /// Service

  @override
  Future<void> start() {
    super.start();

    final subscription = targetingValues$.listen((v) => targetingValues = v);
    disposer.autoDispose(subscription);

    return null;
  }

  Future<void> _pullAds() async {
    /// going to pick an Ad from the "ready" stream Ads.
    final readyAds = await adRepository.getReadyList(targetingValues);

    if (readyAds.length == 0) {
      // unload if there is no candidate
      _pickedAd = null;
      Log.debug('AdScheduler beating');
      return null;
    }

    Ad pickedAd;

    if (readyAds.length == 1) {
      pickedAd = readyAds.first;
    } else {
      // FIXME It supposes to figure out which ad is best for displaying.
      pickedAd = readyAds[_random.nextInt(readyAds.length - 1)];
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
        '${targetingValues == null ? "." : ", with $targetingValues."}');

    return null;
  }

  final Random _random = Random();
}
