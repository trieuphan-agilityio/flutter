import 'dart:async';

import 'package:ad_stream/src/modules/base/service_status.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

mixin ServiceStatusMixin {
  final StreamController<ServiceStatus> status$Controller =
      BehaviorSubject<ServiceStatus>();

  /// Exposes the services's status via a stream.
  Stream<ServiceStatus> get status$ {
    // 1. Skips if service status is same as the previous.
    // 2. Ensure that the stream transformation only execute once.
    return _status$ ??=
        status$Controller.stream.distinct().skipInitialStopped();
  }

  @mustCallSuper
  dispose() {
    status$Controller.close();
  }

  /// A cache instance of [status$] that keep the result of stream transformation
  /// for next use.
  Stream<ServiceStatus> _status$;
}
