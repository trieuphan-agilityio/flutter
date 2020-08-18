import 'dart:async';
import 'dart:math';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/ad/ad_repository.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:rxdart/rxdart.dart';

abstract class AdScheduler {
  /// Ad that is ready for displaying.
  Ad get adForDisplay;

  /// Targeting
  Stream<PassengerGender> gender$;
  Stream<PassengerAgeRange> ageRange$;
  Stream<List<Keyword>> keywords$;
  Stream<List<Area>> areas$;
}

class AdSchedulerImpl with ServiceMixin implements AdScheduler, Service {
  final AdRepository adRepository;
  final Config config;
  Stream<PassengerGender> gender$;
  Stream<PassengerAgeRange> ageRange$;
  Stream<List<Keyword>> keywords$;
  Stream<List<Area>> areas$;

  AdSchedulerImpl(
    this.adRepository,
    this.config,
    this.gender$,
    this.ageRange$,
    this.keywords$,
    this.areas$,
  ) : targetingValues = TargetingValues() {
    backgroundTask = ServiceTask(
      _pullAds,
      config.defaultAdSchedulerRefreshInterval,
    );
  }

  /// Ad that matched targeting values and is placed here to wait for displaying.
  Ad _pickedAd;

  /// A set of targeting value that helps narrows who sees ads and helps
  /// advertisers reach an intended audience with their campaigns.
  TargetingValues targetingValues;

  /// AdScheduler

  Ad get adForDisplay => _pickedAd ?? config.defaultAd;

  /// Service

  @override
  Future<void> start() {
    super.start();

    final subscription =
        CombineLatestStream.combine4(gender$, ageRange$, keywords$, areas$,
            (gender, ageRange, keywords, areas) {
      TargetingValues values = TargetingValues();
      values.add(gender);
      values.add(ageRange);
      values.addAll(keywords);
      values.addAll(areas);
      return values;
    }).listen((value) {
      targetingValues = value;
    });

    _disposer.autoDispose(subscription);

    Log.info('AdScheduler started.');
    return null;
  }

  @override
  Future<void> stop() {
    super.stop();
    _disposer.cancel();
    Log.info('AdScheduler stopped.');
    return null;
  }

  Future<void> _pullAds() async {
    /// going to pick an Ad from the "ready" stream Ads.
    final readyAds = await adRepository.getReadyList(targetingValues);

    if (readyAds.length == 0) {
      // unload if there is no candidate
      _pickedAd = null;
      Log.info('AdScheduler beating');
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
      Log.info('AdScheduler beating');
      return null;
    }

    // choose this Ad for displaying
    _pickedAd = pickedAd;

    Log.info('AdScheduler picked Ad{id: ${_pickedAd.shortId}'
        ', creativeId: ${_pickedAd.creative.shortId}'
        ', version: ${_pickedAd.version}}');

    return null;
  }

  final Random _random = Random();

  final Disposer _disposer = Disposer();
}
