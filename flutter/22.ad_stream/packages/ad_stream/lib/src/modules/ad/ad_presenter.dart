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

class AdPresenterImpl
    with PresenterMixin<AdView>, ServiceMixin
    implements AdPresenter, Service {
  AdPresenterImpl(this.adScheduler, this.config)
      : displaying$Controller = StreamController<Ad>.broadcast(),
        finish$Controller = StreamController<Ad>.broadcast(),
        skip$Controller = StreamController<Ad>.broadcast(),
        fail$Controller = StreamController<AdDisplayError>.broadcast() {
    backgroundTask = ServiceTask(
      _runTask,
      config.defaultAdPresenterHealthCheckInterval,
    );
  }

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

  /// Keep tracking the current displaying Ad for reporting.
  /// Null means that there is no candidate.
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
    // stop displaying if service is stopped.
    if (!isStarted) return;

    _displayingAd = adScheduler.adForDisplay;

    // no ad, no display
    if (_displayingAd == null) {
      Log.info('AdPresenter is waiting for Ad...');
      // FIXME it should prepare a null displayable object instead.
      view.display(null);
      return;
    }

    /// Ad to DisplayableCreative
    view.display(DisplayableCreative(
      ad: _displayingAd,
      canSkipAfter: _displayingAd.canSkipAfter,
      isSkippable: _displayingAd.isSkippable,
      duration:
          Duration(seconds: _displayingAd.timeBlocks * config.timeBlockToSecs),
    ));

    Log.info('AdPresenter is displaying Ad{id: ${_displayingAd.shortId}'
        ', creativeId: ${_displayingAd.creative.shortId}'
        ', version: ${_displayingAd.version}}');
  }

  /// TaskService

  @override
  Future<void> start() {
    super.start();
    Log.info('AdPresenter started.');
    return null;
  }

  @override
  Future<void> stop() {
    super.stop();
    Log.info('AdPresenter stopped.');
    return null;
  }

  Future<void> _runTask() {
    // wake it up if find out that it's waiting for new Ad to display
    if (_displayingAd == null) {
      _displayNewAdIfNeeds();
    }
    return null;
  }
}
