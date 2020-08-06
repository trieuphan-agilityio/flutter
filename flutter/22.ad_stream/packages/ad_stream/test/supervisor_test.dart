import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:ad_stream/src/modules/supervisor/supervisor.dart';
import 'package:test/test.dart';

import 'utils.dart';

main() {
  group('Supervisor', () {
    final supervisor = SupervisorImpl(
        AlwaysStrongPowerProvider(), AlwaysAllowPermissionController());

    test('can start/stop services it manages', () async {
      final mockService = _MockService();
      supervisor.addService(mockService);

      supervisor.start();
      await flushMicrotasks();

      supervisor.stop();
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
