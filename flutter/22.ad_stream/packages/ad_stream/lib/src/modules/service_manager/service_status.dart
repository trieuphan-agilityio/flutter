import 'dart:async';

enum ServiceStatus { STARTED, STOPPED }

extension ServiceStatus$ on Stream<ServiceStatus> {
  /// Prevent emit STOPPED if service haven't started yet.
  Stream<ServiceStatus> skipInitialStopped() {
    bool hasStartOnce = false;

    return transform(StreamTransformer.fromHandlers(handleData: (s, sink) {
      if (s == ServiceStatus.STARTED) {
        if (!hasStartOnce) hasStartOnce = true;
        sink.add(s);
      } else {
        if (hasStartOnce) sink.add(s);
      }
    }));
  }

  Stream<void> startedOnly() {
    return where((status) => status == ServiceStatus.STARTED);
  }

  Stream<void> stoppedOnly() {
    return where((status) => status == ServiceStatus.STOPPED);
  }
}
