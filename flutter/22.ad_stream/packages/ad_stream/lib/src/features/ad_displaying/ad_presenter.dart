import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/ad/ad_scheduler.dart';
import 'package:meta/meta.dart';

/// View component of AdPresentable
abstract class AdViewable {
  display(DisplayableCreative creative);
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
}

abstract class AdPresentable implements Presentable<AdViewable> {
  Stream<Ad> get finishStream;
  Stream<Ad> get skipStream;
  Stream<AdDisplayError> get failStream;

  /// Send new Ad to display to View
  attemptToDisplay(Ad ad);

  /// Some Ads is shippable,
  skip(Ad ad);

  /// finish is called when the Ad finished its display Time Block.
  finish(Ad ad);

  /// fail is called when View has error on displaying Ad.
  /// for example: Files on storage is damaged.
  fail(Ad ad, Error err);
}

/// Error happens while displaying a creative
@immutable
class AdDisplayError {
  final Ad ad;
  final Error error;

  AdDisplayError(this.ad, this.error);
}

class AdPresenter with PresenterMixin<AdViewable> implements AdPresentable {
  final AdScheduler adScheduler;
  final StreamController<Ad> finishStreamController;
  final StreamController<Ad> skipStreamController;
  final StreamController<AdDisplayError> failStreamController;

  AdPresenter(this.adScheduler)
      : finishStreamController = StreamController<Ad>.broadcast(),
        skipStreamController = StreamController<Ad>.broadcast(),
        failStreamController = StreamController<AdDisplayError>.broadcast();

  Stream<Ad> get finishStream => finishStreamController.stream;
  Stream<Ad> get skipStream => skipStreamController.stream;
  Stream<AdDisplayError> get failStream => failStreamController.stream;

  attemptToDisplay(Ad ad) {
    /// Ad to DisplayableCreative
    view.display(DisplayableCreative(
      ad: ad,
      canSkipAfter: ad.canSkipAfter,
      isSkippable: ad.isSkippable,
      duration: Duration(seconds: ad.timeBlocks),
    ));
  }

  fail(Ad ad, Error err) {
    failStreamController.add(AdDisplayError(ad, err));
    _attemptToDisplayNewAd();
  }

  finish(Ad ad) {
    finishStreamController.add(ad);
    _attemptToDisplayNewAd();
  }

  skip(Ad ad) {
    skipStreamController.add(ad);
    _attemptToDisplayNewAd();
  }

  _attemptToDisplayNewAd() {
    final newAd = adScheduler.getAdForDisplay();
    attemptToDisplay(newAd);
  }
}
