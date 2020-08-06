import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/supervisor/supervisor.dart';

const String _kGpsControllerIdentifier = 'GPS_CONTROLLER';

abstract class GpsController implements ManageableService {
  /// Provider a pair of Latitude & Longitude, is updated corresponding to
  /// the current Location of the device.
  Stream<LatLng> get latLng;
}

class FixedGpsController implements GpsController {
  final StreamController<LatLng> controller;

  FixedGpsController() : controller = StreamController<LatLng>.broadcast();

  Stream<LatLng> get latLng => controller.stream;

  /// ==========================================================================
  /// ManageableService
  /// ==========================================================================

  String get identifier => _kGpsControllerIdentifier;

  Future<void> start() {
    Log.info('FixedGpsController is starting');
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      controller.add(LatLng(76.0, 106.0));
    });
    return null;
  }

  Future<void> stop() {
    Log.info('FixedGpsController is stopping');
    timer.cancel();
    timer = null;
    return null;
  }

  Timer timer;
}
