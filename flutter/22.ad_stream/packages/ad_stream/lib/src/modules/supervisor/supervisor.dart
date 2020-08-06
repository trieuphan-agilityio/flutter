import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';

enum ServiceStatus { START, STOP }

/// Services that are managed by [Supervisor].
/// Checkout [SupervisorServices] to see how they are hooked together.
abstract class ManageableService {
  String get identifier;
  Future<void> start();
  Future<void> stop();
}

/// A central service manager that propagate START, STOP events to all services
/// it's managing.
abstract class Supervisor {
  Stream<ServiceStatus> get status;

  addService(ManageableService service);
  removeService(String identifier);

  /// Start it.
  ///
  /// Typically, it should be hooked to the root view lifecycle.
  /// Service should be started when the app is ready to serve.
  start();

  /// All managed services also be stopped until another components resume this.
  stop();
}

/// SupervisorMixin contains common methods/properties that a Supervisor should have.
mixin SupervisorMixin on Supervisor {
  final List<ManageableService> managingServices = [];

  addService(ManageableService service) {
    managingServices.add(service);
  }

  removeService(String identifier) {
    managingServices.removeWhere((srv) => srv.identifier == identifier);
  }

  start() {
    for (final srv in managingServices) {
      // ignore: cancel_subscriptions
      final subscription = status.listen((s) {
        if (s == ServiceStatus.START)
          srv.start();
        else
          srv.stop();
      });
      serviceDisposables.putIfAbsent(srv.identifier, () => subscription);
    }
  }

  stop() {
    for (final srv in managingServices) {
      srv.stop();
    }

    for (final entry in serviceDisposables.entries) {
      entry.value.cancel();
    }
    serviceDisposables.clear();
  }

  final Map<String, StreamSubscription<ServiceStatus>> serviceDisposables = {};
}

class SupervisorImpl extends Supervisor with SupervisorMixin {
  SupervisorImpl(
    this.powerProvider,
    this.permissionController,
  ) : statusStreamController = StreamController<ServiceStatus>.broadcast();

  final PowerProvider powerProvider;
  final PermissionController permissionController;

  final StreamController<ServiceStatus> statusStreamController;

  /// Check if supervisor has ever started yet?
  /// It's useful for dismissing STOP event if it haven't started yet.
  bool _hasStartedOnce = false;

  /// Exposes the services's status via a stream.
  Stream<ServiceStatus> get status {
    //  Skips if service status is equal to the previous.
    return statusStreamController.stream.distinct();
  }

  PowerStatus _powerStatus;
  setPowerStatus(PowerStatus powerStatus) {
    _powerStatus = powerStatus;
  }

  PermissionStatus _permissionStatus;
  setPermissionStatus(PermissionStatus permissionStatus) {
    _permissionStatus = permissionStatus;
  }

  ServiceStatus getServiceStatus() {
    if (_powerStatus == PowerStatus.STRONG &&
        _permissionStatus == PermissionStatus.ALLOWED) {
      return ServiceStatus.START;
    } else {
      return ServiceStatus.STOP;
    }
  }

  @override
  start() {
    super.start();

    // start monitoring the status of Power Provider
    // TODO manage pause, resume, cancel events along with upstream streams.
    disposables.add(powerProvider.status.listen((status) {
      Log.debug('Supervisor observed a change, PowerProvider: $status');
      setPowerStatus(status);
      _emitServiceStatusIfNeeds();
    }));

    // start monitoring the status of Permission Controller
    disposables.add(permissionController.status.listen((status) {
      Log.debug('Supervisor observed a change, PermissionController: $status');
      setPermissionStatus(status);
      _emitServiceStatusIfNeeds();
    }));
  }

  @override
  stop() {
    super.stop();

    for (final disposable in disposables) {
      disposable.cancel();
    }
    disposables.clear();
  }

  /// Added START/STOP event to the status stream.
  /// It will dismiss STOP event if it haven't started yet.
  _emitServiceStatusIfNeeds() {
    final _status = getServiceStatus();
    if (!_hasStartedOnce && _status == ServiceStatus.STOP) return;
    statusStreamController.add(getServiceStatus());
  }

  List<StreamSubscription> disposables = [];
}
