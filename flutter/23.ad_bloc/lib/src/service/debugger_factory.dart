import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/model.dart';

import 'gps/debug_route.dart';
import 'gps/debug_route_loader.dart';

abstract class DebuggerFactory {
  static DebuggerFactory of(BuildContext context) {
    return Provider.of<DebuggerFactory>(context);
  }

  PermissionDebugger get permissionDebugger;
  PowerDebugger get powerDebugger;
  GpsDebugger get gpsDebugger;

  void driverOnboarded();

  /// Load debug routes were defined.
  Future<List<DebugRoute>> loadRoutes();

  /// Replay the records [LatLng] value from sample data.
  /// It would produce events follow the order and time of the recorded.
  void drivingOnRoute(DebugRoute route);
}

class PermissionDebugger extends Equatable {
  final bool isAllowed;

  PermissionDebugger(this.isAllowed);

  @override
  List<Object> get props => [isAllowed];
}

class PowerDebugger extends Equatable {
  final bool isStrong;

  PowerDebugger(this.isStrong);

  @override
  List<Object> get props => [isStrong];
}

class GpsDebugger {
  final Stream<LatLng> latLng$;

  const GpsDebugger(this.latLng$);
}

class DebuggerFactoryImpl implements DebuggerFactory {
  PermissionDebugger get permissionDebugger => _permissionDebugger;
  PermissionDebugger _permissionDebugger;

  enablePermissionDebugger(bool isAllowed) {
    _permissionDebugger = PermissionDebugger(isAllowed);
  }

  disablePermissionDebugger() {
    _permissionDebugger = null;
  }

  PowerDebugger get powerDebugger => _powerDebugger;
  PowerDebugger _powerDebugger;

  enablePowerDebugger(bool isStrong) {
    _powerDebugger = PowerDebugger(isStrong);
  }

  disablePowerDebugger() {
    _powerDebugger = null;
  }

  driverOnboarded() {
    enablePermissionDebugger(true);
    enablePowerDebugger(true);
  }

  GpsDebugger _gpsDebugger;
  GpsDebugger get gpsDebugger => _gpsDebugger;

  Future<List<DebugRoute>> loadRoutes() {
    return DebugRouteLoader.singleton().load();
  }

  drivingOnRoute(DebugRoute route) {
    final controller = StreamController<LatLng>.broadcast();

    _gpsDebugger = GpsDebugger(controller.stream);

    controller.onListen = () {
      StreamSubscription<LatLng> subscription = route.latLng$.listen(
        controller.add,
        onDone: controller.close,
      );
      controller.onCancel = subscription.cancel;
    };
  }
}
