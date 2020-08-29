import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/models/targeting_value.dart';
import 'package:ad_stream/src/modules/base/debugger.dart';
import 'package:ad_stream/src/modules/gps/debugger/debug_route.dart';
import 'package:ad_stream/src/modules/gps/debugger/gps_debugger.dart';

@visibleForTesting
class MockGpsDebugger with DebuggerMixin implements GpsDebugger {
  final Stream<LatLng> _latLng$;

  MockGpsDebugger(this._latLng$);

  Stream<LatLng> get latLng$ => _latLng$;

  Future<List<DebugRoute>> loadRoutes() {
    throw UnimplementedError();
  }

  pause() {
    throw UnimplementedError();
  }

  resume() {
    throw UnimplementedError();
  }

  simulate(DebugRoute route) {
    throw UnimplementedError();
  }

  stop() {
    throw UnimplementedError();
  }
}
