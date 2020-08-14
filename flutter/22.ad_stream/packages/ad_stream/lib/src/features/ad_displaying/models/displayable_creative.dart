import 'package:ad_stream/models.dart';
import 'package:meta/meta.dart';

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
        ',\n  canSkipAfter: ${canSkipAfter}s'
        ',\n  isSkippable: $isSkippable\n}';
  }
}
