import 'package:ad_stream/src/creative/creative.dart';
import 'package:meta/meta.dart';

class Ad {
  final String id;

  final Creative creative;

  /// Number of TimeBlock is assigned to this Ad to display Creative on.
  /// Typically 1 TimeBlock is 15 seconds.
  final int timeBlocks;

  /// Skippable ads allow viewers to skip ads after 6 seconds if they wish.
  /// Advertiser specify the duration limit for skippable ads.
  ///
  /// Zero value indicates that ad cannot be skipped.
  final int canSkipAfter;

  bool get isSkippable => canSkipAfter == 0;

  final DateTime createdAt;
  final DateTime lastModifiedAt;

  Ad({
    @required this.id,
    @required this.creative,
    @required this.timeBlocks,
    @required this.canSkipAfter,
    @required this.createdAt,
    @required this.lastModifiedAt,
  });
}
