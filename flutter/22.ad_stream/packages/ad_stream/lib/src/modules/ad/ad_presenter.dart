import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/config.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/models/ad_display_error.dart';
import 'package:ad_stream/src/modules/ad/ad_scheduler.dart';
import 'package:ad_stream/src/modules/base/service.dart';

/// View component of AdPresentable
abstract class AdView {
  display(DisplayableCreative creative);
}

/// A Presenter of Ad, it helps to de-couple the view's lifecycle to other
/// component like [AdScheduler].
///
/// While the UI engine is preparing for showing the [AdView], [AdScheduler] already
/// run in another isolate to get the Ad ready.
abstract class AdPresenter
    implements Service<DisplayableCreative>, Presenter<AdView> {
  Stream<Ad> get finish$;
  Stream<Ad> get skip$;
  Stream<AdDisplayError> get fail$;
  Stream<Ad> get displaying$;

  /// Some Ads is skippable,
  skip();

  /// finish is called when the Ad finished its display Time Block.
  finish();

  /// fail is called when View has error on displaying Ad.
  /// for example: Files on storage is damaged.
  fail(Error err);
}

class AdPresenterImpl
    with PresenterMixin<AdView>, ServiceMixin
    implements AdPresenter {
  AdPresenterImpl(
    this.adScheduler,
    this._adPresenterConfigProvider,
    this._adConfigProvider,
  )   : displaying$Controller = StreamController<Ad>.broadcast(),
        finish$Controller = StreamController<Ad>.broadcast(),
        skip$Controller = StreamController<Ad>.broadcast(),
        fail$Controller = StreamController<AdDisplayError>.broadcast();

  final AdScheduler adScheduler;
  // ignore: unused_field
  final AdPresenterConfigProvider _adPresenterConfigProvider;
  final AdConfigProvider _adConfigProvider;

  Stream<Ad> get displaying$ => displaying$Controller.stream;
  Stream<Ad> get finish$ => finish$Controller.stream;
  Stream<Ad> get skip$ => skip$Controller.stream;
  Stream<AdDisplayError> get fail$ => fail$Controller.stream;

  final StreamController<Ad> displaying$Controller;
  final StreamController<Ad> finish$Controller;
  final StreamController<Ad> skip$Controller;
  final StreamController<AdDisplayError> fail$Controller;

  Stream<DisplayableCreative> get value$ => displaying$.map(
        (ad) => DisplayableCreative(
          ad: ad,
          canSkipAfter: ad.canSkipAfter,
          isSkippable: ad.isSkippable,
          duration: Duration(
            seconds: ad.timeBlocks * _adConfigProvider.adConfig.timeBlockToSecs,
          ),
        ),
      );

  /// Keep tracking the current displaying Ad for reporting.
  /// Null means that there is no candidate.
  Ad _displayingAd;

  StreamSubscription<Ad> adSubscription;

  @override
  start() async {
    super.start();

    adSubscription = adScheduler.ad$.listen((ad) {
      _displayNewAdIfNeeds(ad);
    });
  }

  fail(Error err) {
    if (_displayingAd != null) {
      fail$Controller.add(AdDisplayError(_displayingAd, err));
    }
    _resumeAdSubscriptionIfNeeds();
  }

  finish() {
    if (_displayingAd != null) {
      finish$Controller.add(_displayingAd);
    }
    _resumeAdSubscriptionIfNeeds();
  }

  skip() {
    if (_displayingAd != null) {
      skip$Controller.add(_displayingAd);
    }
    _resumeAdSubscriptionIfNeeds();
  }

  _resumeAdSubscriptionIfNeeds() {
    if (adSubscription != null && adSubscription.isPaused) {
      adSubscription?.resume();
    }
  }

  _displayNewAdIfNeeds(Ad ad) {
    // stop displaying if service is stopped.
    if (!isStarted) return;

    _displayingAd = ad;

    // no ad, no display
    if (_displayingAd == null) {
      // FIXME it should prepare a null displayable object instead.
      view.display(null);

      Log.info('AdPresenterImpl beating');
      return;
    }

    // wait for the ad to display before receiving new Ad.
    adSubscription?.pause();

    // Ad to DisplayableCreative
    view.display(DisplayableCreative(
      ad: _displayingAd,
      canSkipAfter: _displayingAd.canSkipAfter,
      isSkippable: _displayingAd.isSkippable,
      duration: Duration(
        seconds: _displayingAd.timeBlocks *
            _adConfigProvider.adConfig.timeBlockToSecs,
      ),
    ));

    Log.info('AdPresenterImpl is displaying ${_displayingAd.shortId}'
        '-${_displayingAd.creative.shortId}'
        '-v${_displayingAd.version}.');
  }
}

@immutable
class DisplayableCreative {
  /// Original ad object uses for reference
  final Ad ad;

  /// duration indicates how long the ad should be displayed
  final Duration duration;

  /// allow viewers to skip ads after 5 seconds if they wish
  final int canSkipAfter;

  /// indicates whether ad is skippable
  final bool isSkippable;

  DisplayableCreative({
    @required this.ad,
    @required this.duration,
    @required this.canSkipAfter,
    @required this.isSkippable,
  });

  String get wellFormatString {
    return 'DisplayableCreative{\n  id: ${ad.creative.shortId}'
        ',\n  duration: ${duration.inSeconds}s'
        ',\n  isSkippable: $isSkippable'
        ',\n  canSkipAfter: ${canSkipAfter}s\n}';
  }
}
