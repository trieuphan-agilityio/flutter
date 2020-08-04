import 'package:ad_stream/src/ad/ad.dart';

import 'ad_scheduler.dart';
import 'package:meta/meta.dart';

abstract class Presenter<ViewType> {
  /// View component is attached to this presenter.
  /// It could be nullable when the View is disposed by View engine.
  ViewType get view;

  /// Attach a View to a Presenter.
  /// It usually happens when View engine starts rendering the View.
  attach(ViewType newView);

  /// Detach a View from a Presenter.
  /// It usually happens when View engine re-new or kill the View.
  detach();
}

/// View component of AdPresentable
abstract class AdViewable {
  displayAd(Ad ad);
  hideSkipButton();
  showSkipButton();
  showSkipButtonOnCountDown(int remainingInSecs);
}

abstract class AdPresentable implements Presenter<AdViewable> {
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

abstract class AdPresenter implements AdPresentable {
  Stream<Ad> displaySuccessStream;
  Stream<Ad> skipStream;
  Stream<AdDisplayError> errorStream;
}

/// Error happens while displaying a creative
@immutable
class AdDisplayError {
  final Ad ad;
  final Error error;

  AdDisplayError(this.ad, this.error);
}

mixin PresenterMixin<ViewType> {
  ViewType _view;
  ViewType get view => _view;

  attach(ViewType newView) => _view = newView;
  detach() => _view = null;
}

class AdPresenterImpl with PresenterMixin<AdViewable> implements AdPresenter {
  final AdScheduler adScheduler;

  AdPresenterImpl(this.adScheduler);

  @override
  Stream<Ad> displaySuccessStream;

  @override
  Stream<AdDisplayError> errorStream;

  @override
  Stream<Ad> skipStream;

  @override
  attemptToDisplay(Ad ad) {
    // TODO: implement attemptToDisplay
    throw UnimplementedError();
  }

  @override
  fail(Ad ad, Error err) {
    // TODO: implement fail
    throw UnimplementedError();
  }

  @override
  finish(Ad ad) {
    // TODO: implement finish
    throw UnimplementedError();
  }

  @override
  skip(Ad ad) {
    // TODO: implement skip
    throw UnimplementedError();
  }
}
