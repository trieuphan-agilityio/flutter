import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/permission/debugger/permission_debugger.dart';
import 'package:ad_stream/src/modules/permission/permission_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

import 'gps_controller.dart';
import 'gps_options.dart';

/// A [GpsAdapter] implementation that uses geolocator package.
class AdapterForGeolocator implements GpsAdapter {
  final Geolocator _geolocator;
  final PermissionDebugger _permissionDebugger;

  AdapterForGeolocator(this._geolocator, this._permissionDebugger);

  Stream<LatLng> buildStream(GpsOptions options) {
    // cannot build stream if lacking the permission
    if (_permissionDebugger.delegate.state == PermissionState.denied) {
      return null;
    }

    return _geolocator
        .getPositionStream(_gpsOptionsToLocationOptions(options))
        .flatMap((p) {
      Log.debug('GpsAdapterForGeolocator detected $p.');
      return p == null
          ? Stream<LatLng>.empty()
          : Stream<LatLng>.value(LatLng(p.latitude, p.longitude));
    }).asBroadcastStream();
  }

  LocationOptions _gpsOptionsToLocationOptions(GpsOptions gpsOptions) {
    assert(gpsOptions.accuracy != null, 'GpsAccuracy must not be null.');

    LocationAccuracy locationAccuracy;
    if (_gpsLocationMap.containsKey(gpsOptions.accuracy)) {
      locationAccuracy = _gpsLocationMap[gpsOptions.accuracy];
    }

    assert(locationAccuracy != null, 'LocationAccuracy must not be null');

    return LocationOptions(
        accuracy: locationAccuracy, distanceFilter: gpsOptions.distanceFilter);
  }

  /// A map that indicates according value between GpsAccuracy and LocationAccuracy.
  final Map<GpsAccuracy, LocationAccuracy> _gpsLocationMap = {
    GpsAccuracy.best: LocationAccuracy.best,
    GpsAccuracy.high: LocationAccuracy.high,
    GpsAccuracy.low: LocationAccuracy.low,
  };
}
