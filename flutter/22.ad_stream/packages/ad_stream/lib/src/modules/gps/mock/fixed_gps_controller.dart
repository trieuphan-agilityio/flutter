import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/gps/gps_controller.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:rxdart/rxdart.dart';

class FixedGpsController with ServiceMixin implements GpsController {
  final Config _config;
  final StreamController<LatLng> _latLng$Controller;

  FixedGpsController(this._config)
      : _latLng$Controller = BehaviorSubject<LatLng>() {
    backgroundTask = ServiceTask(
      _refreshLocation,
      _config.defaultGpsControllerRefreshInterval,
    );
  }

  Stream<LatLng> get latLng$ => _latLng$Controller.stream;

  /// Service

  @override
  Future<void> start() {
    super.start();

    // this essential service should start as soon as it can
    // so that other service can consume its value on starting.
    _refreshLocation();

    Log.info('GpsController started.');
    return null;
  }

  @override
  Future<void> stop() {
    super.stop();
    Log.info('GpsController stopped.');
    return null;
  }

  _refreshLocation() {
    _latLng$Controller.add(LatLng(76.0, 106.0));
  }
}
