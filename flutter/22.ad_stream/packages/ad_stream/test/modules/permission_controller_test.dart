import 'package:ad_stream/src/modules/permission/debugger/permission_debugger.dart';
import 'package:ad_stream/src/modules/permission/debugger/permission_debugger_state.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/permission/permission_state.dart';
import 'package:ad_stream/src/modules/storage/pref_storage.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

import '../common.dart';
import '../common/permission_plugin.dart';

main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  List<PermissionState> emittedValues;
  List<String> errors;
  bool isDone;
  PermissionController permissionController;
  PrefStoreWriting mockPrefStore;

  // Utility to test stream's state of Permission Controller's implementations.
  expectDone(bool expected) {
    if (permissionController is PermissionControllerImpl) {
      expect(isDone, expected);
      expect(
        (permissionController as PermissionControllerImpl).isTimerStopped,
        expected,
      );
    }

    // debugger must keep the stream open to be able to resume via debug dashboard.
    if (permissionController is PermissionDebuggerImpl) {
      expect(isDone, false);
    }
  }

  [
    // Test real implementation of [PermissionController]
    () => PermissionControllerImpl(),

    // When wrapped in a debugger, real implementation of [PermissionController]
    // must not change.
    () {
      mockPrefStore = MockPrefStoreWriting();
      return PermissionDebuggerImpl(PermissionControllerImpl(), mockPrefStore)
        ..setDebugState(PermissionDebuggerState.off);
    },
  ].forEach((impl) {
    group(impl, () {
      setUp(() {
        emittedValues = [];
        errors = [];
        isDone = false;
        permissionController = impl();

        permissionController.state$.listen(
          emittedValues.add,
          onError: errors.add,
          onDone: () => isDone = true,
        );
      });

      tearDown(() {
        permissionPluginCleanUp();
      });

      test('can start and stop immediately', () async {
        permissionPluginAllDenied();

        permissionController.start();
        await flushMicrotasks();

        expect(errors, []);
        expect(emittedValues, [PermissionState.denied]);
        if (permissionController is PermissionControllerImpl) {
          expect(
            (permissionController as PermissionControllerImpl).isTimerStopped,
            false,
          );
        }
        expect(isDone, false);

        permissionController.stop();
        await flushMicrotasks();

        expect(errors, []);
        expect(emittedValues, [PermissionState.denied]);
        if (permissionController is PermissionControllerImpl) {
          expect(
            (permissionController as PermissionControllerImpl).isTimerStopped,
            true,
          );
        }
        expect(isDone, false);
      });

      test(
          'is started when all permissions were granted '
          'then it should emit allowed event and stop its timer', () async {
        permissionPluginAllAllowed();

        fakeAsync((async) {
          permissionController.start();

          async.elapse(Duration(seconds: 3));

          expect(errors, []);
          expect(emittedValues, [
            PermissionState.denied,
            PermissionState.allowed,
          ]);
          expectDone(true);
        });
      });

      test(
          'is started when permission was denied '
          'then it should emit denied event and start its timer', () async {
        permissionPluginAllDenied();

        fakeAsync((async) {
          permissionController.start();

          async.elapse(Duration(seconds: 3));

          expect(errors, []);
          expect(emittedValues, [PermissionState.denied]);
          expectDone(false);
        });
      });

      test('can be granted permission after being denied', () async {
        permissionPluginAllDenied();

        fakeAsync((async) {
          permissionController.start();

          async.elapse(Duration(seconds: 3));
          expect(errors, []);
          expect(emittedValues, [PermissionState.denied]);
          expectDone(false);

          // then allow permissions
          permissionPluginAllAllowed();

          async.elapse(Duration(seconds: 3));
          expect(errors, []);
          expect(emittedValues, [
            PermissionState.denied,
            PermissionState.allowed,
          ]);
          expectDone(true);
        });
      });
    });
  });

  group('PermissionDebuggerImpl', () {
    PermissionController permissionController;
    PermissionDebugger permissionDebugger;

    setUp(() {
      permissionController = PermissionControllerImpl();
      mockPrefStore = MockPrefStoreWriting();
      permissionDebugger = PermissionDebuggerImpl(
        permissionController,
        mockPrefStore,
      );
    });

    test('can start', () async {
      permissionPluginAllAllowed();
      permissionDebugger.start();
    });
  });
}
