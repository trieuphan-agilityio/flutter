import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/permission/permission_state.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:ad_stream/src/modules/base/service.dart';
import 'package:ad_stream/src/modules/base/service_status.dart';

/// A central service manager that propagate [ServiceStatus.started], [ServiceStatus.stopped]
/// events to all services it's managing.
abstract class ServiceManager extends Service {
  /// Initialise subscriptions.
  /// Typically, it should be hooked to the root view lifecycle.
  /// Service should be started when the app is ready to serve.
  init();

  /// All managed services also be stopped until another components resume this.
  dispose();
}

class ServiceManagerImpl with ServiceMixin implements ServiceManager {
  final Stream<PowerState> power$;
  final Stream<PermissionState> permission$;

  /// NOTE: this disposer is different to the one provided by [ServiceMixn].
  /// It's used in [init] and [dispose] methods, in other hand [ServiceMixin]'s
  /// disposer is for [start] and [stop] method.
  final Disposer _disposerForInit = Disposer();

  ServiceManagerImpl(this.power$, this.permission$);

  init() {
    final subscription = power$.combineLatest(permission$, (power, permission) {
      Log.info('ServiceManager observed $power, $permission');
      if (power == PowerState.strong && permission == PermissionState.allowed) {
        return true;
      } else {
        return false;
      }
    }).listen((bool isStarted) => isStarted ? start() : stop());

    _disposerForInit.autoDispose(subscription);

    Log.info('ServiceManager initialized.');
  }

  dispose() {
    // propagate stopped event to its listener.
    stop();

    // stop listening to power and permission streams
    _disposerForInit.cancel();

    Log.info('ServiceManager disposed.');
    return null;
  }
}
