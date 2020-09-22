import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/model.dart';

import 'ad_repository/debug_ad_loader.dart';
import 'ad_repository/debug_date_time.dart';
import 'gps/debug_route.dart';
import 'gps/debug_route_loader.dart';

abstract class DebuggerFactory {
  static DebuggerFactory of(BuildContext context) {
    return Provider.of<DebuggerFactory>(context);
  }

  PermissionDebugger get permissionDebugger;
  PowerDebugger get powerDebugger;
  GpsDebugger get gpsDebugger;
  AdRepositoryDebugger get adRepositoryDebugger;

  void driverOnboarded();

  /// Load predefined date time when [AdRepository] can read and serve
  /// corresponding Ad values at that specified time.
  Future<List<DebugDateTime>> loadDebugDateTimes();

  /// Replay the recorded [Iterable<Ad>] value from sample data.
  /// It would produce events follow the order and time of the recorded.
  void driverPickUpPassengerOnDateTime(DebugDateTime pickedUpTime);

  /// Load debug routes were defined.
  Future<List<DebugRoute>> loadRoutes();

  /// Replay the recorded [LatLng] value from sample data.
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

class GpsDebugger extends Equatable {
  final Stream<LatLng> latLng$;

  const GpsDebugger(this.latLng$);

  @override
  List<Object> get props => [latLng$];
}

class AdRepositoryDebugger extends Equatable {
  final Stream<Iterable<Ad>> ads$;

  AdRepositoryDebugger(this.ads$);

  @override
  List<Object> get props => [ads$];
}

class DebuggerFactoryImpl implements DebuggerFactory {
  PermissionDebugger get permissionDebugger => _permissionDebugger;
  PermissionDebugger _permissionDebugger;

  enablePermissionDebugger(bool isAllowed) {
    _permissionDebugger = PermissionDebugger(isAllowed);
  }

  disablePermissionDebugger() => _permissionDebugger = null;

  PowerDebugger get powerDebugger => _powerDebugger;
  PowerDebugger _powerDebugger;

  enablePowerDebugger(bool isStrong) {
    _powerDebugger = PowerDebugger(isStrong);
  }

  disablePowerDebugger() => _powerDebugger = null;

  driverOnboarded() {
    enablePermissionDebugger(true);
    enablePowerDebugger(true);
  }

  Future<List<DebugDateTime>> loadDebugDateTimes() async {
    return DebugAdLoader.singleton().load();
  }

  driverPickUpPassengerOnDateTime(DebugDateTime pickedUpTime) {
    _adRepositoryDebugger = AdRepositoryDebugger(pickedUpTime.ads$);
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

  disableGpsDebugger() => _gpsDebugger = null;

  AdRepositoryDebugger _adRepositoryDebugger;
  AdRepositoryDebugger get adRepositoryDebugger => _adRepositoryDebugger;
}
