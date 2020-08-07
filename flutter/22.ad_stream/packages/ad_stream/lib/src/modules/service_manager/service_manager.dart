import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';

enum ServiceStatus { START, STOP }

/// Services that are managed by [ServiceManager].
/// Checkout [ServiceManager] to see how they are hooked together.
abstract class ManageableService {
  /// A unique string that identify a service.
  String get identifier;

  /// Concrete class should implement this method to init its background jobs
  /// such as Timer and Subscription.
  Future<void> start();

  /// Concrete class should implement this method to release subscription or pause
  /// a timer.
  Future<void> stop();
}

/// A central service manager that propagate START, STOP events to all services
/// it's managing.
abstract class ServiceManager {
  /// Expose a service status stream. Typically, service doesn't need to access
  /// this stream directly, instead, it can implement [ManageableService] interface
  /// and be added to the managing list via [addService] method.
  Stream<ServiceStatus> get status;

  /// Add a service to the managing list.
  addService(ManageableService service);

  /// Remove a service from the managing list.
  removeService(String identifier);

  /// Initialise subscriptions.
  ///
  /// Typically, it should be hooked to the root view lifecycle.
  /// Service should be started when the app is ready to serve.
  init();

  /// All managed services also be stopped until another components resume this.
  dispose();
}

class ServiceManagerImpl implements ServiceManager {
  ServiceManagerImpl(
    this.powerStatusStream,
    this.permissionStatusStream,
  ) : statusStreamController = StreamController<ServiceStatus>.broadcast();

  final Stream<PowerStatus> powerStatusStream;
  final Stream<PermissionStatus> permissionStatusStream;

  final StreamController<ServiceStatus> statusStreamController;

  final List<ManageableService> managingServices = [];

  /// Exposes the services's status via a stream.
  Stream<ServiceStatus> get status {
    //  Skips if service status is equal to the previous.
    return statusStreamController.stream.distinct();
  }

  addService(ManageableService service) {
    managingServices.add(service);
  }

  removeService(String identifier) {
    managingServices.removeWhere((srv) => srv.identifier == identifier);
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

  init() {
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

    // start monitoring the status of Power Provider
    // TODO manage pause, resume, cancel events along with upstream streams.
    disposables.add(powerStatusStream.listen((status) {
      Log.debug('ServiceManager observed a change, PowerProvider: $status');
      setPowerStatus(status);
      _emitServiceStatusIfNeeds();
    }));

    // start monitoring the status of Permission Controller
    disposables.add(permissionStatusStream.listen((status) {
      Log.debug(
          'ServiceManager observed a change, PermissionController: $status');
      setPermissionStatus(status);
      _emitServiceStatusIfNeeds();
    }));
  }

  dispose() {
    for (final srv in managingServices) {
      srv.stop();
    }

    for (final entry in serviceDisposables.entries) {
      entry.value.cancel();
    }
    serviceDisposables.clear();

    for (final disposable in disposables) {
      disposable.cancel();
    }
    disposables.clear();
  }

  /// Check if service manager has ever started yet?
  /// It's useful for dismissing STOP event if it haven't started yet.
  bool _hasStartedOnce = false;

  /// Added START/STOP event to the status stream.
  /// It will dismiss STOP event if it haven't started yet.
  _emitServiceStatusIfNeeds() {
    final _status = getServiceStatus();
    if (!_hasStartedOnce && _status == ServiceStatus.STOP) {
      return;
    }
    if (!_hasStartedOnce && _status == ServiceStatus.START) {
      _hasStartedOnce = true;
    }
    statusStreamController.add(getServiceStatus());
  }

  final List<StreamSubscription> disposables = [];
  final Map<String, StreamSubscription<ServiceStatus>> serviceDisposables = {};
}
