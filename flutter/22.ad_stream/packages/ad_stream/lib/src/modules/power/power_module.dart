import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/power/debugger/power_debugger.dart';

import 'power_provider.dart';

/// Declare public interface that an PowerModule should expose
abstract class PowerModuleLocator {
  @provide
  PowerProvider get powerProvider;
}

/// A source of dependency provider for the injector.
/// It contains Power related services, such as Battery.
@module
class PowerModule {
  @provide
  @singleton
  PowerProvider powerProvider(PowerDebugger powerDebugger) {
    return powerDebugger;
  }

  @provide
  @singleton
  PowerDebugger powerDebugger() {
    return PowerDebuggerImpl(delegate: PowerProviderImpl());
  }
}
