import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/gps/debugger/gps_debugger.dart';
import 'package:ad_stream/src/modules/gps/gps_options.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

abstract class GpsController implements Service {
  /// Provider a pair of Latitude & Longitude, is updated corresponding to
  /// the current Location of the device.
  Stream<LatLng> get latLng$;
}

class GpsControllerImpl with ServiceMixin implements GpsController {
  GpsControllerImpl(
    this._gpsOptions$,
    this._geolocator, {
    @required GpsDebugger debugger,
  })  : _$switcher = BehaviorSubject<Stream<LatLng>>(),
        _gpsDebugger = debugger {
    _gpsDebugger.isOn.addListener(() {
      // depends on the state of Gps Debugger, the switcher will choose to use
      // the stream from debugger or it could the latest stream that was built
      // with the latest GpsOptions if needs.
      if (_gpsDebugger.isOn.value) {
        _$switcher.add(_gpsDebugger.latLng$);
      } else if (_latest$WithOptions == null) {
        // if the stream hasn't built yet, it supposes to assign to empty stream
        // instead of keeping the last setup.
        //
        // This initialization is different to `Stream.empty()`, it will not
        // trigger done event.
        _$switcher.add(StreamController<LatLng>().stream);
      } else {
        _$switcher.add(_latest$WithOptions);
      }
    });
  }

  final GpsDebugger _gpsDebugger;

  /// Accept options as a stream to allow changing it on the flight.
  final Stream<GpsOptions> _gpsOptions$;

  final BehaviorSubject<Stream<LatLng>> _$switcher;

  /// Stream that was built with latest [GpsOptions] from [_gpsOptions$]
  Stream<LatLng> _latest$WithOptions;

  /// Backing field of [latLng$].
  /// It helps to cache the stream transformation result.
  Stream<LatLng> _latLng$;

  /// Emits values from the most recently emitted Stream was built with latest
  /// [GpsOptions] derived from [_gpsOptions$]
  Stream<LatLng> get latLng$ {
    return _latLng$ ??= _$switcher.stream.switchLatest();
  }

  /// Build new [latLng$] stream with the given [GpsOptions]
  Stream<LatLng> _build$WithOptions(GpsOptions options) {
    return _geolocator
        .getPositionStream(_gpsOptionsToLocationOptions(options))
        .flatMap((p) {
      Log.debug('GpsController detected $p.');
      return p == null
          ? Stream<LatLng>.empty()
          : Stream<LatLng>.value(LatLng(p.latitude, p.longitude));
    }).asBroadcastStream();
  }

  /// Service

  @override
  Future<void> start() {
    super.start();

    // listen to the gpsOptions$ stream to create new gps stream with new options.
    final sub = _gpsOptions$.listen((gpsOptions) {
      _latest$WithOptions = _build$WithOptions(gpsOptions);

      // switch to this new stream if the debugger was off.
      if (!_gpsDebugger.isOn.value) {
        _$switcher.add(_latest$WithOptions);
      }
    });

    disposer.autoDispose(sub);
    return null;
  }

  final Geolocator _geolocator;

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
