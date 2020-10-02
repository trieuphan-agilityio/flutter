import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/config.dart';
import 'package:ad_bloc/model.dart';

import 'ad_repository/debug_ad_loader.dart';
import 'ad_repository/debug_date_time.dart';
import 'gps/debug_route.dart';
import 'gps/debug_route_loader.dart';

class Debugger extends Equatable {
  final ConfigDebugger configDebugger;
  final PermissionDebugger permissionDebugger;
  final PowerDebugger powerDebugger;
  final GpsDebugger gpsDebugger;
  final AdRepositoryDebugger adRepositoryDebugger;
  final CameraDebugger cameraDebugger;

  Debugger(
      {this.configDebugger,
      this.permissionDebugger,
      this.powerDebugger,
      this.gpsDebugger,
      this.adRepositoryDebugger,
      this.cameraDebugger});

  @override
  List<Object> get props => [
        permissionDebugger,
        powerDebugger,
        gpsDebugger,
        adRepositoryDebugger,
        cameraDebugger
      ];
}

class DebuggerBuilder extends ChangeNotifier {
  static DebuggerBuilder of(BuildContext context) {
    return Provider.of<DebuggerBuilder>(context);
  }

  Debugger debugger = Debugger();
  ConfigDebugger _configDebugger;
  AdRepositoryDebugger _adRepositoryDebugger;
  CameraDebugger _cameraDebugger;
  GpsDebugger _gpsDebugger;
  PermissionDebugger _permissionDebugger;
  PowerDebugger _powerDebugger;

  reset() {
    _configDebugger = null;
    _adRepositoryDebugger = null;
    _cameraDebugger = null;
    _gpsDebugger = null;
    _permissionDebugger = null;
    _powerDebugger = null;
  }

  inTestEnvironment() {
    _configDebugger = ConfigDebugger(Config(
      timeBlockToSecs: 2,
      defaultAd: kDefaultAd,
      defaultAdEnabled: true,
      creativeBaseUrl: 'http://localhost:8080/public/creatives/',
      defaultAdRepositoryRefreshInterval: 15,
    ));
  }

  enablePermissionDebugger(bool isAllowed) {
    _permissionDebugger = PermissionDebugger(isAllowed);
  }

  enablePowerDebugger(bool isStrong) {
    _powerDebugger = PowerDebugger(isStrong);
  }

  driverOnboarded() {
    enablePermissionDebugger(true);
    enablePowerDebugger(true);
  }

  /// Load predefined date time when [AdRepository] can read and serve
  /// corresponding Ad values at that specified time.
  Future<List<DebugDateTime>> loadDebugDateTimes() async {
    return DebugAdLoader.singleton().load();
  }

  /// Replay the recorded [Iterable<Ad>] value from sample data.
  /// It would produce events follow the order and time of the recorded.
  driverPickUpPassengerOnDateTime(DebugDateTime pickedUpTime) {
    _adRepositoryDebugger = AdRepositoryDebugger(pickedUpTime.ads$);
  }

  /// Load debug routes were defined.
  Future<List<DebugRoute>> loadRoutes() {
    return DebugRouteLoader.singleton().load();
  }

  /// Replay the recorded [LatLng] value from sample data.
  /// It would produce events follow the order and time of the recorded.
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

  /// Specify output of [CameraController]
  void passengerPhotoAt(String filePath) {
    _cameraDebugger = CameraDebugger(filePath);
  }

  build() {
    debugger = Debugger(
      configDebugger: _configDebugger,
      adRepositoryDebugger: _adRepositoryDebugger,
      cameraDebugger: _cameraDebugger,
      gpsDebugger: _gpsDebugger,
      permissionDebugger: _permissionDebugger,
      powerDebugger: _powerDebugger,
    );
    notifyListeners();
  }
}

class ConfigDebugger extends Equatable {
  final Config config;

  ConfigDebugger(this.config);

  @override
  List<Object> get props => [config];
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

  const AdRepositoryDebugger(this.ads$);

  @override
  List<Object> get props => [ads$];
}

class CameraDebugger extends Equatable {
  final String filePath;

  const CameraDebugger(this.filePath);

  @override
  List<Object> get props => [filePath];
}
