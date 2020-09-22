import 'package:ad_bloc/src/service/permission_controller.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiver/time.dart';

import '../utils.dart';

main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  List<bool> emittedValues;
  List<String> errors;
  bool isDone;
  PermissionController permissionController;

  group('PermissionController', () {
    setUp(() {
      emittedValues = [];
      errors = [];
      isDone = false;
      permissionController = PermissionControllerImpl();

      permissionController.isAllowed$.listen(
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
      expect(emittedValues, [false]);
      expect(isDone, false);

      permissionController.stop();
      await flushMicrotasks();

      expect(errors, []);
      expect(emittedValues, [false]);
      expect(isDone, false);
    });

    test(
        'is started when all permissions were granted '
        'then it should emit allowed event', () async {
      permissionPluginAllAllowed();

      permissionController.start();
      await flushMicrotasks();

      expect(errors, []);
      expect(emittedValues, [true]);
      expect(isDone, false);
    });

    test(
        'is started when permission was denied '
        'then it should emit denied event', () async {
      permissionPluginAllDenied();

      permissionController.start();
      await flushMicrotasks();

      expect(errors, []);
      expect(emittedValues, [false]);
      expect(isDone, false);
    });

    test('can be granted permission after being denied', () async {
      permissionPluginAllDenied();

      fakeAsync((async) {
        permissionController.start();
        async.elapse(aSecond);

        expect(errors, []);
        expect(emittedValues, [false]);
        expect(isDone, false);

        // then allow permissions
        permissionPluginAllAllowed();

        // assume that permission controller refresh its content every 1s
        async.elapse(Duration(seconds: 2));

        expect(errors, []);
        expect(emittedValues, [false, true]);
        expect(isDone, false);
      });
    });
  });
}
