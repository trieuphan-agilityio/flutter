import 'package:ad_bloc/model.dart';

class DebugRoute {
  final String id;
  final String name;
  final Stream<LatLng> latLng$;

  DebugRoute(this.id, this.name, this.latLng$) : assert(!latLng$.isBroadcast);
}
