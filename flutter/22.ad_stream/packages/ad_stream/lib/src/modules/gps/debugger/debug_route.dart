import 'package:ad_stream/models.dart';
import 'package:meta/meta.dart';

@immutable
class DebugRoute {
  final String id;
  final String name;
  final Stream<LatLng> latLng$;

  DebugRoute(this.id, this.name, this.latLng$);
}
