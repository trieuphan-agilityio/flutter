import 'package:ad_stream/base.dart';

import 'power_provider.dart';

/// Declare public interface that an PowerServices should expose
abstract class PowerServiceLocator {
  @provide
  PowerProvider get powerProvider;
}

/// A source of dependency provider for the injector.
/// It contains Power related services, such as Battery.
@module
class PowerServices {
  @provide
  @singleton
  PowerProvider powerProvider() {
    return AlwaysStrongPowerProvider();
  }
}
