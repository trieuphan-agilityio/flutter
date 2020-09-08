import 'dart:async';

enum ServiceStatus { started, stopped }

extension ServiceStatus$ on Stream<ServiceStatus> {
  /// Prevent emit STOPPED if service haven't started yet.
  Stream<ServiceStatus> skipInitialStopped() {
    bool hasStartOnce = false;

    return transform(StreamTransformer.fromHandlers(handleData: (s, sink) {
      if (s == ServiceStatus.started) {
        if (!hasStartOnce) hasStartOnce = true;
        sink.add(s);
      } else {
        if (hasStartOnce) sink.add(s);
      }
    }));
  }

  Stream<void> startedOnly() {
    return where((status) => status == ServiceStatus.started);
  }

  Stream<void> stoppedOnly() {
    return where((status) => status == ServiceStatus.stopped);
  }
}
