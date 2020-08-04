import 'package:ad_stream/src/creative/creative.dart';
import 'package:meta/meta.dart';

class Ad {
  final Creative creative;

  /// A hash string indicates whether Creative has changed or not,
  /// usually it's a md5 string.
  /// It could be used for verifying the integrity of the files.
  final String creativeTag;

  /// Number of TimeBlock is assigned to this Ad to display Creative on.
  /// Typically 1 TimeBlock is 15 seconds.
  final int numOfTimeBlocks;

  final DateTime createdAt;
  final DateTime lastModifiedAt;

  Ad({
    @required this.creative,
    @required this.creativeTag,
    @required this.numOfTimeBlocks,
    @required this.createdAt,
    @required this.lastModifiedAt,
  });
}
