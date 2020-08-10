import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/service_manager/service_status.dart';

/// [Service] that is bind its lifecycle to [ServiceManager]'s status stream.
abstract class Service {
  Future<void> start();
  Future<void> stop();

  /// [listen] to the status of [ServiceManager].
  listen(Stream<ServiceStatus> serviceStatus$);
}

/// Declare common methods of [Service]
mixin ServiceMixin on Service {
  listen(Stream<ServiceStatus> status$) {
    status$.startedOnly().listen((_) => start());
    status$.stoppedOnly().listen((_) => stop());
  }
}

/// [Service] that has task is executed periodically with given [defaultRefreshInterval].
abstract class TaskService extends Service {
  /// Default elapse time, typically it should come from [Config].
  int get defaultRefreshInterval;

  /// Background task of the [Service]
  Future<void> runTask();
}

mixin TaskServiceMixin on TaskService {
  Duration get refreshInterval =>
      _refreshInterval ?? Duration(seconds: defaultRefreshInterval);

  set refreshInterval(Duration newValue) {
    _refreshInterval = newValue;
    if (_isStart) {
      runTask();
    }
  }

  @mustCallSuper
  Future<void> start() {
    _isStart = true;
    _timer?.cancel();
    _timer = Timer.periodic(refreshInterval, (_) {
      runTask();
    });
    return null;
  }

  @mustCallSuper
  Future<void> stop() {
    _isStart = false;
    _timer?.cancel();
    _timer = null;
    return null;
  }

  /// persist start state.
  bool _isStart = false;

  /// A timer to periodically refresh ads.
  Timer _timer;

  /// Configurable refresh duration.
  Duration _refreshInterval;
}
