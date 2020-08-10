import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/service_manager/service_status.dart';

abstract class Service {
  Future<void> start();
  Future<void> stop();
  listen(Stream<ServiceStatus> serviceStatus$);
}

mixin ServiceMixin on Service {
  listen(Stream<ServiceStatus> status$) {
    status$.startedOnly().listen((_) => start());
    status$.stoppedOnly().listen((_) => stop());
  }
}

abstract class TaskService extends Service {
  int get defaultRefreshInterval;
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
