import 'dart:async';

import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/permission/permission_state.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:ad_stream/src/modules/service_manager/service_manager.dart';
import 'package:test/test.dart';

import '../common/mocks.dart';
import '../common/utils.dart';

main() {
  ServiceManagerImpl serviceManager;
  _MockService mockService;

  StreamController<PowerState> controllerForPower;
  PowerProvider powerProvider;

  StreamController<PermissionState> controllerForPermission;
  PermissionController permissionController;

  group('ServiceManagerImpl', () {
    setUp(() {
      controllerForPower = StreamController<PowerState>();
      powerProvider = MockPowerProvider(controllerForPower.stream);

      controllerForPermission = StreamController<PermissionState>();
      permissionController =
          MockPermissionController(controllerForPermission.stream);

      serviceManager = ServiceManagerImpl(
        powerProvider.state$,
        permissionController.state$,
      );

      mockService = _MockService();
      mockService.listenTo(serviceManager.status$);
    });

    tearDown(() {
      controllerForPermission.close();
      controllerForPower.close();
    });

    powerStrong() => controllerForPower.add(PowerState.strong);
    powerWeak() => controllerForPower.add(PowerState.weak);

    permissionAllowed() => controllerForPermission.add(PermissionState.allowed);
    permissionDenied() => controllerForPermission.add(PermissionState.denied);

    test('can start/stop services it manages', () async {
      serviceManager.start();
      await flushMicrotasks();

      serviceManager.stop();
      await flushMicrotasks();

      expect(mockService.startCalled, 1);
      expect(mockService.stopCalled, 1);
    });

    test('should not stop service if it have not started yet', () async {
      serviceManager.stop();
      await flushMicrotasks();

      expect(mockService.stopCalled, 0);
    });

    test('should work properly when multiple services listen to', () async {
      final anotherMockService = _MockService();
      anotherMockService.listenTo(serviceManager.status$);

      serviceManager.start();
      await flushMicrotasks();

      serviceManager.stop();
      await flushMicrotasks();

      expect(mockService.startCalled, 1);
      expect(mockService.stopCalled, 1);

      expect(anotherMockService.startCalled, 1);
      expect(anotherMockService.stopCalled, 1);
    });

    test('should stop when power is weak', () async {
      serviceManager.init();
      powerStrong();
      permissionAllowed();
      await flushMicrotasks();

      expect(mockService.startCalled, 1);
      expect(mockService.stopCalled, 0);

      powerWeak();
      await flushMicrotasks();
      expect(mockService.startCalled, 1);
      expect(mockService.stopCalled, 1);
    });

    test('should stop when permission is denied', () async {
      serviceManager.init();
      powerStrong();
      permissionAllowed();
      await flushMicrotasks();

      expect(mockService.startCalled, 1);
      expect(mockService.stopCalled, 0);

      permissionDenied();
      await flushMicrotasks();

      expect(mockService.startCalled, 1);
      expect(mockService.stopCalled, 1);
    });

    test('should stop when it is disposed', () async {
      serviceManager.init();
      serviceManager.dispose();

      expect(mockService.startCalled, 0);
      expect(mockService.stopCalled, 0);
      expect(serviceManager.isStopped, true);
    });
  });
}

class _MockService extends Service with ServiceMixin {
  int startCalled = 0;
  int stopCalled = 0;

  @override
  Future<void> start() {
    super.start();
    startCalled++;
    return null;
  }

  @override
  Future<void> stop() {
    super.stop();
    stopCalled++;
    return null;
  }
}
