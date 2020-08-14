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

  /// Some Ads is skippable,
  skip();

  /// finish is called when the Ad finished its display Time Block.
  finish();

  /// fail is called when View has error on displaying Ad.
  /// for example: Files on storage is damaged.
  fail(Error err);
}

class AdPresenterImpl extends TaskService
    with TaskServiceMixin, ServiceMixin, PresenterMixin<AdView>
    implements AdPresenter {
  AdPresenterImpl(this.adScheduler, this.config)
      : displaying$Controller = StreamController<Ad>.broadcast(),
        finish$Controller = StreamController<Ad>.broadcast(),
        skip$Controller = StreamController<Ad>.broadcast(),
        fail$Controller = StreamController<AdDisplayError>.broadcast();

  final AdScheduler adScheduler;
  final Config config;

  Stream<Ad> get displaying$ => displaying$Controller.stream;
  Stream<Ad> get finish$ => finish$Controller.stream;
  Stream<Ad> get skip$ => skip$Controller.stream;
  Stream<AdDisplayError> get fail$ => fail$Controller.stream;

  final StreamController<Ad> displaying$Controller;
  final StreamController<Ad> finish$Controller;
  final StreamController<Ad> skip$Controller;
  final StreamController<AdDisplayError> fail$Controller;

  // Picked Ad that is ready for display.
  Ad _adToDisplay;

  // Keep tracking the current displaying Ad for reporting.
  Ad _displayingAd;

  fail(Error err) {
    if (_displayingAd != null) {
      fail$Controller.add(AdDisplayError(_displayingAd, err));
    }
    _displayNewAdIfNeeds();
  }

  finish() {
    if (_displayingAd != null) {
      finish$Controller.add(_displayingAd);
    }
    _displayNewAdIfNeeds();
  }

  skip() {
    if (_displayingAd != null) {
      skip$Controller.add(_displayingAd);
    }
    _displayNewAdIfNeeds();
  }

  _displayNewAdIfNeeds() {
    // reset the previous state of displaying Ad.
    _displayingAd = null;

    // stop displaying if service is stopped.
    if (!_isStart) return;

    _adToDisplay = adScheduler.getAdForDisplay();

    // no ad, no display
    if (_adToDisplay == null) {
      Log.info('AdPresenter is waiting for Ad...');
      return;
    }

    /// Ad to DisplayableCreative
    view.display(DisplayableCreative(
      ad: _adToDisplay,
      canSkipAfter: _adToDisplay.canSkipAfter,
      isSkippable: _adToDisplay.isSkippable,
      duration:
          Duration(seconds: _adToDisplay.timeBlocks * config.timeBlockToSecs),
    ));

    _displayingAd = _adToDisplay;

    Log.info('AdPresenter is displaying Ad{id: ${_displayingAd.id}'
        ', version: ${_displayingAd.version}'
        ', creativeId: ${_displayingAd.creative.id}}');
  }

  /// TaskService

  /// intercept start/stop lifecycle to verify before triggering next displaying.
  bool _isStart = false;

  Future<void> start() {
    super.start();
    _isStart = true;
    Log.info('AdPresenter started.');
    return null;
  }

  Future<void> stop() {
    super.stop();
    _isStart = false;
    Log.info('AdPresenter stopped.');
    return null;
  }

  int get defaultRefreshInterval => config.defaultAdPresenterRefreshInterval;

  Future<void> runTask() {
    // wake it up if find out that it's waiting for new Ad to display
    if (_displayingAd == null) {
      _displayNewAdIfNeeds();
    }
    return null;
  }
}
