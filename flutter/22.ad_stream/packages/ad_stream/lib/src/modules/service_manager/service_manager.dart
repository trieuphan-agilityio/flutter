import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/permission/permission_status.dart';
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

  final StreamController<ServiceStatus> status$Controller;
  final Stream<PowerStatus> powerStatus$;
  final Stream<PermissionStatus> permissionStatus$;

  /// Exposes the services's status via a stream.
  Stream<ServiceStatus> get status$ {
    // 1. Skips if service status is same as the previous.
    // 2. Ensure that the stream transformation only execute once.
    return _status$ ??=
        status$Controller.stream.distinct().skipInitialStopped();
  }

  start() {
    Log.info('ServiceManager is starting...');
    final subscription = powerStatus$.combineLatest(
      permissionStatus$,
      (powerStatus, permissionStatus) {
        Log.info('ServiceManager observed $powerStatus, $permissionStatus');
        if (powerStatus == PowerStatus.strong &&
            permissionStatus == PermissionStatus.ALLOWED) {
          return ServiceStatus.START;
        } else {
          return ServiceStatus.STOP;
        }
      },
    ).listen(status$Controller.add, onDone: () {
      Log.info('ServiceManager received Done event from'
          'PowerProvider or PermissionController');
    }, onError: (_) {
      Log.info('ServiceManager received Error event from'
          'PowerProvider or PermissionController');
    });

    autoDispose(subscription);
  }

  stop() {
    status$Controller.add(ServiceStatus.STOP);
    dispose();
  }

  /// A cache of the stream transformation result.
  Stream<ServiceStatus> _status$;
}
