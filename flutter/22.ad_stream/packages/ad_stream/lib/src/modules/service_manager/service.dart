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
