import 'package:ad_stream/src/modules/permission/debugger/permission_debugger.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/permission/permission_state.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

import '../common.dart';
import '../common/permission_plugin.dart';

main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  List<PermissionState> emittedValues;
  List<String> errors;
  bool isDone;
  PermissionControllerImpl permissionController;

  group('PermissionControllerImpl', () {
    setUp(() {
      emittedValues = [];
      errors = [];
      isDone = false;
      permissionController = PermissionControllerImpl();

      permissionController.state$.listen(
        emittedValues.add,
        onError: errors.add,
        onDone: () => isDone = true,
      );
    });

    test(
        'is started when all permissions were granted'
        'then it should emit allowed event and stop its timer', () async {
      permissionPluginAllAllowed();

      fakeAsync((async) {
        permissionController.start();

        flushMicrotasks();
        expect(permissionController.isTimerStopped, true);

        async.elapse(Duration(seconds: 3));
        expect(errors, []);
        expect(emittedValues, [PermissionState.allowed]);
        expect(isDone, true);
      });
    });

    test(
        'is started when permission was denied'
        'then it should emit denied event and start its timer', () async {
      permissionPluginAllDenied();

      fakeAsync((async) {
        permissionController.start();

        flushMicrotasks();
        expect(permissionController.isTimerStopped, false);

        async.elapse(Duration(seconds: 3));
        expect(errors, []);
        expect(emittedValues, [PermissionState.denied]);
        expect(isDone, false);
      });
    });

    test('can be granted permission after being denied', () async {
      permissionPluginAllDenied();

      fakeAsync((async) {
        permissionController.start();

        async.elapse(Duration(seconds: 3));
        expect(errors, []);
        expect(emittedValues, [PermissionState.denied]);
        expect(permissionController.isTimerStopped, false);
        expect(isDone, false);

        // then allow permissions
        permissionPluginAllAllowed();

        async.elapse(Duration(seconds: 3));
        expect(errors, []);
        expect(emittedValues, [
          PermissionState.denied,
          PermissionState.allowed,
        ]);
        expect(permissionController.isTimerStopped, true);
        expect(isDone, true);
      });
    });
  });

  group('PermissionDebuggerImpl', () {
    PermissionController permissionController;
    PermissionDebugger permissionDebugger;

    setUp(() {
      permissionController = PermissionControllerImpl();
      permissionDebugger = PermissionDebuggerImpl(permissionController);
    });

    test('can start', () async {
      permissionPluginAllAllowed();
      permissionDebugger.start();
    });
  });
}
