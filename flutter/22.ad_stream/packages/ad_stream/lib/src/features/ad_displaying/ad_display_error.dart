import 'package:ad_stream/models.dart';
import 'package:meta/meta.dart';

/// Error happens while displaying a creative
@immutable
class AdDisplayError {
  final Ad ad;
  final Error error;

  AdDisplayError(this.ad, this.error);
}
