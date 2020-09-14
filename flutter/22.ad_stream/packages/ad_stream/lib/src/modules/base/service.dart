import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/base/service_status.dart';
import 'package:rxdart/rxdart.dart';

import 'debugger.dart';

/// [Service] that is bind its lifecycle to other [Service]'s status$ stream.
/// Typically, class that implements this interface should use [ServiceMixin].
abstract class Service<T> {
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
mixin ServiceMixin<T> {
  final StreamController<ServiceStatus> _status$Controller =
      BehaviorSubject<ServiceStatus>();

  /// Optional task that is executed background.
  ServiceTask backgroundTask;

  BehaviorSubject<Stream<T>> $switcher = BehaviorSubject<Stream<T>>();
  Stream<T> get value$ => _value$ ??= $switcher.switchLatest();

  /// Take the debugger and its value
  @protected
  acceptDebugger(Debugger<T> debugger,
      {Stream<T> originalValue$, Function onDebuggerIsOff}) {
    assert(debugger != null);
    assert(
      originalValue$ == null || onDebuggerIsOff == null,
      'You must specific originalValue\$ or onDebuggerIsOff callback, not both.',
    );
    assert(
      originalValue$ != null || onDebuggerIsOff != null,
      'You must specific at least an originalValue\$ or onDebuggerIsOff callback.',
    );

    /// depends on the state of the service, the switcher will choose to use
    /// the stream from debugger or its own value.
    final onDebuggerStateChanged = () {
      if (debugger.isOn.value) {
        $switcher.add(debugger.value$);
      } else {
        if (originalValue$ == null) {
          onDebuggerIsOff();
        } else {
          $switcher.add(originalValue$);
        }
      }
    };

    debugger.isOn.addListener(onDebuggerStateChanged);
    onDebuggerStateChanged();
  }

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

  Disposer get disposer => _disposer;

  /// A cache of the stream transformation result.
  Stream<ServiceStatus> _status$;

  /// Backing field of [value$]
  Stream<T> _value$;

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
