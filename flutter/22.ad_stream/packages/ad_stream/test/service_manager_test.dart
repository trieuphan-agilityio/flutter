import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:ad_stream/src/modules/service_manager/service_manager.dart';
import 'package:test/test.dart';

import 'utils.dart';

main() {
  group('Service Manager', () {
    final serviceManager = ServiceManagerImpl(
      AlwaysStrongPowerProvider().status,
      AlwaysAllowPermissionController().status,
    );

    test('can start/stop services it manages', () async {
      final mockService = _MockService();
      serviceManager.addService(mockService);

      serviceManager.init();
      await flushMicrotasks();

      serviceManager.dispose();
      await flushMicrotasks();

      expect(mockService.startCalled, equals(1));
      expect(mockService.stopCalled, equals(1));
    });
  });
}

class _MockService implements ManageableService {
  int startCalled = 0;
  int stopCalled = 0;

  @override
  String get identifier => 'MOCK_SERVICE';

  @override
  Future<void> start() {
    startCalled++;
    return null;
  }

  @override
  Future<void> stop() {
    stopCalled++;
    return null;
  }
}
