import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiver/time.dart';

main() {
  _SimpleService service;

  group('Service', () {
    service = _SimpleService();
    test('can start/stop', () async {
      await service.start();
      expect(service.isStarted, true);
      expect(service.isStopped, false);
      expect(service.backgroundTask, null);

      await service.stop();
      expect(service.isStarted, false);
      expect(service.isStopped, true);
      expect(service.backgroundTask, null);
    });

    test('can run background task', () async {
      int taskRanCount = 0;
      service.backgroundTask = ServiceTask(() {
        taskRanCount++;
      }, aSecond.inSeconds);

      fakeAsync((async) {
        service.start();

        async.elapse(aMinute);
        expect(taskRanCount, 60);

        service.stop();

        // while stopping it supposes to not run.
        async.elapse(aMinute);
        expect(taskRanCount, 60);
      });
    });
  });
}

class _SimpleService with ServiceMixin implements Service {}
