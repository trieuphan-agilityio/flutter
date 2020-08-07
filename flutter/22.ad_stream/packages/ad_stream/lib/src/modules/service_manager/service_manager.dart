import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:ad_stream/src/modules/service_manager/service_status.dart';
import 'package:rxdart/rxdart.dart';

/// A central service manager that propagate [ServiceStatus.START], [ServiceStatus.STOP]
/// events to all services it's managing.
abstract class ServiceManager {
  /// Expose a service status stream. Typically, service doesn't need to access
  /// this stream directly, instead, it can implement [ManageableService] interface
  /// and be added to the managing list via [manage] method.
  Stream<ServiceStatus> get status$;

  /// Initialise subscriptions.
  ///
  /// Typically, it should be hooked to the root view lifecycle.
  /// Service should be started when the app is ready to serve.
  start();

  /// All managed services also be stopped until another components resume this.
  stop();
}

class ServiceManagerImpl extends DisposableController
    with AutoDisposeControllerMixin
    implements ServiceManager {
  ServiceManagerImpl(
    this.powerStatus$,
    this.permissionStatus$,
  ) : status$Controller = BehaviorSubject<ServiceStatus>();

  final Stream<PowerStatus> powerStatus$;
  final Stream<PermissionStatus> permissionStatus$;

  final StreamController<ServiceStatus> status$Controller;

  /// Exposes the services's status via a stream.
  Stream<ServiceStatus> get status$ {
    /// Ensure that the stream transformation only execute once.
    /// TODO write a test for this logic
    if (_status$ == null)
      // Skips if service status is equal to the previous.
      _status$ = status$Controller.stream.distinct().skipInitialStopped();

    return _status$;
  }

  /// A cache of the stream transformation result.
  Stream<ServiceStatus> _status$;

  start() {
    final subscription = powerStatus$.combineLatest(
      permissionStatus$,
      (powerStatus, permissionStatus) {
        if (powerStatus == PowerStatus.STRONG &&
            permissionStatus == PermissionStatus.ALLOWED) {
          return ServiceStatus.STARTED;
        } else {
          return ServiceStatus.STOPPED;
        }
      },
    ).listen(status$Controller.add);

    autoDispose(subscription);
  }

  stop() {
    status$Controller.add(ServiceStatus.STOPPED);
    dispose();
  }
}
