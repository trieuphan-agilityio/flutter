import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:rxdart/rxdart.dart';

abstract class GpsController {
  /// Provider a pair of Latitude & Longitude, is updated corresponding to
  /// the current Location of the device.
  Stream<LatLng> get latLng$;
}

class FixedGpsController extends TaskService
    with ServiceMixin, TaskServiceMixin
    implements GpsController {
  final StreamController<LatLng> latLng$Controller;

  FixedGpsController() : latLng$Controller = BehaviorSubject<LatLng>();

  Stream<LatLng> get latLng$ => latLng$Controller.stream;

  /// Service

  // TODO inject config
  int get defaultRefreshInterval => 30;

  @override
  Future<void> start() {
    super.start();
    Log.info('FixedGpsController is starting');
    return null;
  }

  @override
  Future<void> stop() {
    super.stop();
    Log.info('FixedGpsController is stopping');
    return null;
  }

  @override
  Future<void> runTask() {
    latLng$Controller.add(LatLng(76.0, 106.0));
    return null;
  }
}
