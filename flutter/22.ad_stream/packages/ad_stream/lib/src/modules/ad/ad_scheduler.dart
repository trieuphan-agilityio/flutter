import 'dart:async';
import 'dart:collection';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/config.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/base/service.dart';
import 'package:quiver/time.dart';
import 'package:rxdart/rxdart.dart' show CombineLatestStream;

abstract class AdScheduler {
  /// Ad that is ready for displaying.
  /// The stream is single-subscription, if consumer don't want to receive next
  /// value, go ahead pause the stream and resume when it needs.
  Stream<Ad> get ad$;
}

class AdSchedulerImpl with ServiceMixin implements AdScheduler, Service {
  AdSchedulerImpl(
    this.ads$,
    this.targetingValues$,
    this._adSchedulerConfigProvider,
    this._adConfigProvider,
  ) : ad$Controller = StreamController<Ad>() {
    ad$Controller.onListen = start;
    ad$Controller.onPause = pause;
    ad$Controller.onResume = resume;
    ad$Controller.onCancel = stop;
  }

  final StreamController<Ad> ad$Controller;

  /// Ad that is picked for displaying
  Stream<Ad> get ad$ => ad$Controller.stream;

  /// Ads that are available for displaying if they match targeting values from
  /// [targetinValues$]
  final Stream<List<Ad>> ads$;

  /// Collect a set of targeting value that helps narrows who sees ads and helps
  /// advertisers reach an intended audience with their campaigns.
  final Stream<TargetingValues> targetingValues$;

  /// Service

  @override
  start() async {
    super.start();
    _subscription = _buildSubscription();
    disposer.autoDispose(_subscription);
  }

  pause() {
    _isPaused = true;
    _subscription?.cancel();
  }

  resume() {
    if (_isPaused) {
      _isPaused = false;

      _subscription = _buildSubscription();
      disposer.autoDispose(_subscription);
    }
  }

  /// indicates that the service was paused
  bool _isPaused = false;

  StreamSubscription _buildSubscription() {
    return CombineLatestStream.combine2(
      ads$,
      targetingValues$,
      (List<Ad> ads, TargetingValues targetingValues) {
        return Tuple2(ads, targetingValues);
      },
    ).debounce(aSecond).listen((event) {
      final ads = event.item1;
      final targetingValues = event.item2;
      final matchedAds =
          ads.where((ad) => ad.isMatch(targetingValues)).toList();

      if (matchedAds.length == 0) {
        // unload if there is no candidate
        ad$Controller.add(null);
        Log.debug('AdSchedulerImpl beating');
        return;
      }

      // FIXME It supposes to figure out which ad is best for displaying.
      Ad pickedAd = _rotateCreative(matchedAds);

      // choose this Ad for displaying
      ad$Controller.add(pickedAd);

      bool hasTargetingValues = targetingValues.valuesMap.isNotEmpty;
      Log.info('AdSchedulerImpl picked ${pickedAd.shortId}'
          '-${pickedAd.creative.shortId}'
          '-v${pickedAd.version}'
          '${hasTargetingValues ? ", with ${targetingValues.valuesMap}." : "."}');
    });
  }

  /// use subscription of single-subscription stream to control the lifecycle
  /// of the ad scheduler.
  StreamSubscription _subscription;

  /// A data structure for rotating creatives
  Queue<Ad> _displayingQueue = Queue<Ad>();

  /// Simple algorithm to rotate creatives
  Ad _rotateCreative(Iterable<Ad> ads) {
    _displayingQueue.retainWhere((e) => ads.contains(e));
    for (final ad in ads) {
      if (!_displayingQueue.contains(ad)) {
        _displayingQueue.add(ad);
      }
    }
    return _displayingQueue.removeFirst();
  }

  // ignore: unused_field
  final AdSchedulerConfigProvider _adSchedulerConfigProvider;
  // ignore: unused_field
  final AdConfigProvider _adConfigProvider;
}
