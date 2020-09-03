import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/gps/debugger/gps_debugger.dart';
import 'package:ad_stream/src/modules/gps/gps_options.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:rxdart/rxdart.dart';

abstract class GpsController implements Service {
  /// Provider a pair of Latitude & Longitude, is updated corresponding to
  /// the current Location of the device.
  Stream<LatLng> get latLng$;
}

class GpsControllerImpl with ServiceMixin implements GpsController {
  GpsControllerImpl(
    this._gpsOptions$,
    this._gpsAdapter, {
    @required GpsDebugger debugger,
  })  : _$switcher = BehaviorSubject<Stream<LatLng>>(),
        _gpsDebugger = debugger {
    _gpsDebugger.isOn.addListener(() {
      // depends on the state of Gps Debugger, the switcher will choose to use
      // the stream from debugger or it could the latest stream that was built
      // with the latest GpsOptions if needs.
      if (_gpsDebugger.isOn.value) {
        _$switcher.add(_gpsDebugger.latLng$);
      } else {
        _buildNewStream(_lastGpsOptions);
      }
    });
  }

  /// Debugger for [GpsController]
  final GpsDebugger _gpsDebugger;

  /// Accept options as a stream to allow changing it on the flight.
  final Stream<GpsOptions> _gpsOptions$;

  /// Keep reference to the latest [GpsOptions] from [_gpsOptions$] so that
  /// new stream could be built when debugger is turned on.
  GpsOptions _lastGpsOptions;

  final BehaviorSubject<Stream<LatLng>> _$switcher;

  /// Stream that was built with latest [GpsOptions] from [_gpsOptions$]
  Stream<LatLng> _last$WithOptions;

  /// Backing field of [latLng$].
  /// It helps to cache the stream transformation result.
  Stream<LatLng> _latLng$;

  /// Emits values from the most recently emitted Stream was built with latest
  /// [GpsOptions] derived from [_gpsOptions$]
  Stream<LatLng> get latLng$ {
    return _latLng$ ??= _$switcher.stream.switchLatest();
  }

  /// Service

  @override
  Future<void> start() {
    super.start();

    // listen to the gpsOptions$ stream to create new gps stream with new options.
    final sub = _gpsOptions$.distinct().listen((gpsOptions) {
      _lastGpsOptions = gpsOptions;
      if (isDebuggerOff) {
        _buildNewStream(_lastGpsOptions);
      }
    });

    disposer.autoDispose(sub);
    return null;
  }

  _buildNewStream(GpsOptions gpsOptions) {
    // assign to empty stream if there is no gpsOptions
    if (gpsOptions == null) {
      // This initialization is different to `Stream.empty()`, it will not
      // trigger done event.
      _$switcher.add(StreamController<LatLng>().stream);
    } else {
      _last$WithOptions = _gpsAdapter.buildStream(gpsOptions);

      if (_last$WithOptions == null) {
        // if the stream hasn't built yet, it supposes to assign to empty stream
        // to avoid keeping the last setup.
        _$switcher.add(StreamController<LatLng>().stream);
      } else {
        _$switcher.add(_last$WithOptions);
      }

      Log.debug('GpsController built new stream with $gpsOptions.');
    }
  }

  bool get isDebuggerOff => !_gpsDebugger.isOn.value;

  final GpsAdapter _gpsAdapter;
}

abstract class GpsAdapter {
  /// Build new [latLng$] stream with the given [GpsOptions]
  Stream<LatLng> buildStream(GpsOptions options);
}
