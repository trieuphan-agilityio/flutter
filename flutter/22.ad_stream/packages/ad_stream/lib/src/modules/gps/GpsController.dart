import 'package:ad_stream/models.dart';

abstract class GpsController {
  /// Provider a pair of Latitude & Longitude, is updated corresponding to
  /// the current Location of the device.
  Stream<LatLng> get latLng;
}
