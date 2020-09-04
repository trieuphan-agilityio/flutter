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

    test('can restart the task when refresh interval is changed', () async {
      int taskRanCount = 0;
      int initialRefreshInterval = 3; // 3 secs

      service.backgroundTask = ServiceTask(() {
        taskRanCount++;
      }, initialRefreshInterval);

      fakeAsync((async) {
        service.start();

        async.elapse(Duration(seconds: 9));
        expect(taskRanCount, 3);

        // there are 2 seconds left to finish the task,
        async.elapse(Duration(seconds: 1));

        // and then the refresh interval is change to 10 seconds.
        service.backgroundTask.refreshIntervalSecs = 10;

        // then the service should cancel the running task and apply new config.
        async.elapse(Duration(seconds: 21));
        expect(taskRanCount, 5);
      });
    });
  });
}

class _SimpleService with ServiceMixin implements Service {}
