import 'package:ad_stream/src/modules/permission/mock/permission_controller.dart';
import 'package:ad_stream/src/modules/power/mock/power_provider.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:ad_stream/src/modules/service_manager/service_manager.dart';
import 'package:test/test.dart';

import '../common/utils.dart';

main() {
  group('ServiceManagerImpl', () {
    ServiceManagerImpl serviceManager;
    _MockService mockService;

    setUp(() {
      serviceManager = ServiceManagerImpl(
        AlwaysStrongPowerProvider().state$,
        AlwaysAllowPermissionController().state$,
      );

      mockService = _MockService();
      mockService.listen(serviceManager.status$);
    });

    test('can start/stop services it manages', () async {
      serviceManager.start();
      await flushMicrotasks();

      serviceManager.stop();
      await flushMicrotasks();

      expect(mockService.startCalled, equals(1));
      expect(mockService.stopCalled, equals(1));
    });

    test('should not stop service if it have not started yet', () async {
      serviceManager.stop();
      await flushMicrotasks();

      expect(mockService.stopCalled, equals(0));
    });

    test('should work properly with multiple services', () async {
      final anotherMockService = _MockService();
      anotherMockService.listen(serviceManager.status$);

      serviceManager.start();
      await flushMicrotasks();

      serviceManager.stop();
      await flushMicrotasks();

      expect(mockService.startCalled, equals(1));
      expect(mockService.stopCalled, equals(1));

      expect(anotherMockService.startCalled, equals(1));
      expect(anotherMockService.stopCalled, equals(1));
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
