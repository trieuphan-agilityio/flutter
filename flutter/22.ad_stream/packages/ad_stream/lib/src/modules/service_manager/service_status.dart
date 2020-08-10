import 'dart:async';

enum ServiceStatus { START, STOP }

extension ServiceStatus$ on Stream<ServiceStatus> {
  /// Prevent emit STOPPED if service haven't started yet.
  Stream<ServiceStatus> skipInitialStopped() {
    bool hasStartOnce = false;

    return transform(StreamTransformer.fromHandlers(handleData: (s, sink) {
      if (s == ServiceStatus.START) {
        if (!hasStartOnce) hasStartOnce = true;
        sink.add(s);
      } else {
        if (hasStartOnce) sink.add(s);
      }
    }));
  }

  Stream<void> startedOnly() {
    return where((status) => status == ServiceStatus.START);
  }

  Stream<void> stoppedOnly() {
    return where((status) => status == ServiceStatus.STOP);
  }
}
