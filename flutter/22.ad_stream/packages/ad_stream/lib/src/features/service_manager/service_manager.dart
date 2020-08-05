import 'dart:async';

import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:meta/meta.dart';
import 'package:stream_transform/stream_transform.dart';

enum ServiceStatus { START, STOP }

abstract class ServiceManager {
  Stream<ServiceStatus> get statusStream;

  /// Start it.
  ///
  /// Typically, it should be hooked to the root view lifecycle.
  /// Service should be started when the app is ready to serve.
  start();

  /// All managed services must be stopped until another components resume this.
  stop();
}

class ServiceManagerImpl implements ServiceManager {
  final PowerProvider powerProvider;
  final PermissionController permissionController;

  final StreamController<ServiceStatus> statusStreamController;

  Stream<ServiceStatus> get statusStream {
    return statusStreamController.stream;
  }

  ServiceManagerImpl({
    @required this.powerProvider,
    @required this.permissionController,
  }) : statusStreamController = StreamController<ServiceStatus>.broadcast();

  @override
  start() {
    final subscription = powerProvider.status
        .combineLatest(permissionController.status,
            (PowerStatus powerStatus, PermissionStatus permissionStatus) {
      if (powerStatus == PowerStatus.STRONG &&
          permissionStatus == PermissionStatus.ALLOWED) {
        return ServiceStatus.START;
      } else {
        return ServiceStatus.STOP;
      }
    }).listen(statusStreamController.add);

    disposables.add(subscription);
  }

  @override
  stop() {
    for (final disposable in disposables) {
      disposable.cancel();
    }
  }

  List<StreamSubscription> disposables;
}
