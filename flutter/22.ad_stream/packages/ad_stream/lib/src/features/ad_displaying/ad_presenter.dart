import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/features/ad_displaying/models/displayable_creative.dart';
import 'package:ad_stream/src/models/ad_display_error.dart';
import 'package:ad_stream/src/modules/ad/ad_scheduler.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';

/// View component of AdPresentable
abstract class AdView {
  display(DisplayableCreative creative);
}

/// A Presenter of Ad, it helps to de-couple the view's lifecycle to other
/// component like [AdScheduler].
///
/// While the UI engine is preparing for showing the [AdView], [AdScheduler] already
/// run in another isolate to get the Ad ready.
abstract class AdPresenter implements Presenter<AdView> {
  Stream<Ad> get finish$;
  Stream<Ad> get skip$;
  Stream<AdDisplayError> get fail$;
  Stream<Ad> get displaying$;

  /// Some Ads is shippable,
  skip();

  /// finish is called when the Ad finished its display Time Block.
  finish();

  /// fail is called when View has error on displaying Ad.
  /// for example: Files on storage is damaged.
  fail(Error err);
}

class AdPresenterImpl extends Service
    with ServiceMixin, PresenterMixin<AdView>
    implements AdPresenter {
  AdPresenterImpl(this.adScheduler)
      : displaying$Controller = StreamController<Ad>.broadcast(),
        finish$Controller = StreamController<Ad>.broadcast(),
        skip$Controller = StreamController<Ad>.broadcast(),
        fail$Controller = StreamController<AdDisplayError>.broadcast();

  final AdScheduler adScheduler;

  Stream<Ad> get displaying$ => displaying$Controller.stream;
  Stream<Ad> get finish$ => finish$Controller.stream;
  Stream<Ad> get skip$ => skip$Controller.stream;
  Stream<AdDisplayError> get fail$ => fail$Controller.stream;

  final StreamController<Ad> displaying$Controller;
  final StreamController<Ad> finish$Controller;
  final StreamController<Ad> skip$Controller;
  final StreamController<AdDisplayError> fail$Controller;

  Ad _adToDisplay;

  fail(Error err) {
    fail$Controller.add(AdDisplayError(_adToDisplay, err));
    _attemptToDisplayNewAd();
  }

  finish() {
    finish$Controller.add(_adToDisplay);
    _attemptToDisplayNewAd();
  }

  skip() {
    skip$Controller.add(_adToDisplay);
    _attemptToDisplayNewAd();
  }

  _attemptToDisplayNewAd() {
    _adToDisplay = adScheduler.getAdForDisplay();
    if (_adToDisplay == null) return;

    /// Ad to DisplayableCreative
    view.display(DisplayableCreative(
      ad: _adToDisplay,
      canSkipAfter: _adToDisplay.canSkipAfter,
      isSkippable: _adToDisplay.isSkippable,
      duration: Duration(seconds: _adToDisplay.timeBlocks),
    ));
  }

  @override
  Future<void> start() {
    return null;
  }

  @override
  Future<void> stop() {
    return null;
  }
}
