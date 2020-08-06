import 'package:ad_stream/base.dart';

import 'gps_controller.dart';

/// Declare public interface that an GpsServices should expose
abstract class GpsServiceLocator {
  @provide
  GpsController get gpsController;
}

/// A source of dependency provider for the injector.
/// It contains Gps related services, such as Battery.
@module
class GpsServices {
  @provide
  @singleton
  GpsController gpsController() {
    return FixedGpsController();
  }
}
