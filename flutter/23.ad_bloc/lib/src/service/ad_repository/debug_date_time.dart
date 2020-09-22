import 'package:ad_bloc/model.dart';

/// Each DebugDateTime has an associated stream of Ads.
/// [AdRepository] can consume this stream to produce the list of Ad over time.
class DebugDateTime {
  final String id;
  final String name;
  final DateTime dateTime;
  final Stream<List<Ad>> ads$;

  DebugDateTime(this.name, this.dateTime, this.ads$)
      : assert(!ads$.isBroadcast),
        id = 'debug_date_time_${dateTime.millisecondsSinceEpoch}';
}
