import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/models/targeting_value.dart';
import 'package:ad_stream/src/modules/base/debugger.dart';
import 'package:ad_stream/src/modules/gps/debugger/debug_route.dart';
import 'package:ad_stream/src/modules/gps/debugger/gps_debugger.dart';

@visibleForTesting
class MockGpsDebugger with DebuggerMixin implements GpsDebugger {
  final Stream<LatLng> _value$;

  MockGpsDebugger(this._value$);

  Stream<LatLng> get value$ => _value$;

  Future<List<DebugRoute>> loadRoutes() {
    throw UnimplementedError();
  }

  pauseSimulating() {
    throw UnimplementedError();
  }

  resumeSimulating() {
    throw UnimplementedError();
  }

  simulateRoute(DebugRoute route) {
    throw UnimplementedError();
  }

  stopSimulating() {
    throw UnimplementedError();
  }

  useLocation(LatLng latLng) {
    throw UnimplementedError();
  }
}
