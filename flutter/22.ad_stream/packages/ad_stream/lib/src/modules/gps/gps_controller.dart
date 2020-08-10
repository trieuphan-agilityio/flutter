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

class FixedGpsController extends Service
    with ServiceMixin
    implements GpsController {
  final StreamController<LatLng> latLng$Controller;

  FixedGpsController() : latLng$Controller = BehaviorSubject<LatLng>();

  Stream<LatLng> get latLng$ => latLng$Controller.stream;

  /// Service

  @override
  Future<void> start() {
    Log.info('FixedGpsController is starting');
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      latLng$Controller.add(LatLng(76.0, 106.0));
    });
    return null;
  }

  @override
  Future<void> stop() {
    Log.info('FixedGpsController is stopping');
    _timer?.cancel();
    _timer = null;
    return null;
  }

  Timer _timer;
}
