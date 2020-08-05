import 'package:ad_stream/ad_stream.dart';
import 'package:ad_stream_app/base.dart';
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

abstract class AdPresentable implements Presenter<AdViewable> {
  Stream<Ad> get successStream;
  Stream<Ad> get skipStream;
  Stream<AdDisplayError> get errorStream;

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

  AdPresenter(this.adScheduler);

  @override
  Stream<Ad> successStream;

  @override
  Stream<AdDisplayError> errorStream;

  @override
  Stream<Ad> skipStream;

  @override
  attemptToDisplay(Ad ad) {
    /// Ad to DisplayableCreative
    view.display(DisplayableCreative(
      ad: ad,
      canSkipAfter: ad.canSkipAfter,
      isSkippable: ad.isSkippable,
      duration: Duration(seconds: ad.timeBlocks),
    ));
  }

  @override
  fail(Ad ad, Error err) {
    // TODO send analytics event

    final ad = adScheduler.getAdForDisplay();
    attemptToDisplay(ad);
  }

  @override
  finish(Ad ad) {
    // TODO send analytics event

    final ad = adScheduler.getAdForDisplay();
    attemptToDisplay(ad);
  }

  @override
  skip(Ad ad) {
    // TODO send analytics event

    final ad = adScheduler.getAdForDisplay();
    attemptToDisplay(ad);
  }
}
