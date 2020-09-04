import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/service_manager/service_status.dart';
import 'package:rxdart/rxdart.dart';

/// [Service] that is bind its lifecycle to other [Service]'s status$ stream.
/// Typically, class that implements this interface should use [ServiceMixin].
abstract class Service {
  /// Service has its own status stream. Other service can bind to this status
  /// via [listenTo] method.
  Stream<ServiceStatus> get status$;

  Future<void> start();
  Future<void> stop();
  Future<void> restart();

  bool get isStarted;
  bool get isStopped;

  /// Using [listenTo] method, a service can bind its lifecycle to other service.
  listenTo(Stream<ServiceStatus> serviceStatus$);

  /// Provide a simple way to disposing subscription that service is consuming.
  Disposer get disposer;
}

/// Declare common methods of [Service]
mixin ServiceMixin {
  final StreamController<ServiceStatus> _status$Controller =
      BehaviorSubject<ServiceStatus>();

  /// Optional task that is executed background.
  ServiceTask backgroundTask;

  Disposer get disposer => _disposer;

  @mustCallSuper
  Future<void> start() {
    _isStarted = true;
    _status$Controller.add(ServiceStatus.started);

    // schedule background task on stop.
    backgroundTask?.start();

    Log.info('$runtimeType started.');
    return null;
  }

  @mustCallSuper
  Future<void> stop() {
    _isStarted = false;
    _status$Controller.add(ServiceStatus.stopped);

    // stop background task if needs
    backgroundTask?.stop();

    // cancel registered subscriptions for auto dispose.
    disposer.cancel();

    Log.info('$runtimeType stopped.');
    return null;
  }

  @mustCallSuper
  Future<void> restart() async {
    if (isStarted) await stop();
    await start();

    Log.info('$runtimeType restarted.');
    return null;
  }

  bool get isStarted => _isStarted;
  bool get isStopped => !_isStarted;

  listenTo(Stream<ServiceStatus> status$) {
    status$.startedOnly().listen((_) => start());
    status$.stoppedOnly().listen((_) => stop());
  }

  /// Exposes the services's status via a stream.
  Stream<ServiceStatus> get status$ {
    // 1. Skips if service status is same as the previous.
    // 2. Ensure that the stream transformation only execute once.
    // 3. Dismiss initial stopped event.
    return _status$ ??=
        _status$Controller.stream.distinct().skipInitialStopped();
  }

  /// A cache of the stream transformation result.
  Stream<ServiceStatus> _status$;

  /// persist start state.
  bool _isStarted = false;

  /// Simple way to cancel subscriptions if needs.
  final Disposer _disposer = Disposer();
}

class ServiceTask {
  /// Background task of the [Service]
  final Function runTask;

  /// Time in seconds that must elapse before the service executes its task again.
  /// Typically it should come from [ConfigFactory].
  int _refreshIntervalSecs;

  ServiceTask(this.runTask, int refreshIntervalSecs)
      : _refreshIntervalSecs = refreshIntervalSecs;

  start() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: _refreshIntervalSecs), (_) {
      runTask();
    });

    return null;
  }

  stop() {
    _timer?.cancel();
    _timer = null;
    return null;
  }

  set refreshIntervalSecs(int newValue) {
    _refreshIntervalSecs = newValue;
    stop();
    start();
  }

  /// A timer to periodically refresh ads.
  Timer _timer;
}
