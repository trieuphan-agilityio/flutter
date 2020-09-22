import 'package:ad_bloc/base.dart';

/// [Service] that is bind its lifecycle to other [Service]'s status$ stream.
/// Typically, class that implements this interface should use [ServiceMixin].
abstract class Service<T> {
  Future<void> start();
  Future<void> stop();
  Future<void> restart();

  bool get isStarted;
  bool get isStopped;

  /// Provide a simple way to disposing subscription that service is consuming.
  Disposer get disposer;
}

/// Declare common methods of [Service]
mixin ServiceMixin {
  /// Optional task that is executed background.
  ServiceTask backgroundTask;

  @visibleForTesting
  int startCalled = 0;

  @mustCallSuper
  Future<void> start() {
    _isStarted = true;

    // schedule background task on stop.
    backgroundTask?.start();

    startCalled++;

    Log.info('$runtimeType started.');
    return null;
  }

  @visibleForTesting
  int stopCalled = 0;

  @mustCallSuper
  Future<void> stop() {
    _isStarted = false;

    // stop background task if needs
    backgroundTask?.stop();

    // cancel registered subscriptions for auto dispose.
    disposer.cancel();

    stopCalled++;

    Log.info('$runtimeType stopped.');
    return null;
  }

  @visibleForTesting
  int restartCalled = 0;

  @mustCallSuper
  Future<void> restart() async {
    if (isStarted) await stop();
    await start();

    restartCalled++;

    Log.info('$runtimeType restarted.');
    return null;
  }

  bool get isStarted => _isStarted;
  bool get isStopped => !_isStarted;

  Disposer get disposer => _disposer;

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

    _isStarted = true;
    return null;
  }

  stop() {
    _timer?.cancel();
    _timer = null;
    _isStarted = false;
    return null;
  }

  set refreshIntervalSecs(int newValue) {
    _refreshIntervalSecs = newValue;

    if (_isStarted) {
      stop();
      start();
    }
  }

  bool _isStarted = false;

  /// A timer to periodically refresh ads.
  Timer _timer;
}
