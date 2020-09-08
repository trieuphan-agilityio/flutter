import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/gps/debugger/gps_debugger.dart';
import 'package:ad_stream/src/modules/gps/gps_options.dart';
import 'package:ad_stream/src/modules/base/service.dart';
import 'package:rxdart/rxdart.dart';

abstract class GpsController implements Service {
  /// Provider a pair of Latitude & Longitude, is updated corresponding to
  /// the current Location of the device.
  Stream<LatLng> get latLng$;
}

class GpsControllerImpl with ServiceMixin<LatLng> implements GpsController {
  GpsControllerImpl(this._gpsOptions$, this._gpsAdapter, this._gpsDebugger)
      : _subject = BehaviorSubject() {
    // depends on the state of Gps Debugger, the switcher will choose to use
    // the stream from debugger or it could the latest stream that was built
    // with the latest GpsOptions if needs.
    acceptDebugger(_gpsDebugger, onDebuggerIsOff: _buildNewStream);
  }

  /// The [latLng$] should be determined along with debugger's value$.
  Stream<LatLng> get latLng$ => _latLng$ ??= value$.distinct();

  final BehaviorSubject<LatLng> _subject;

  /// Debugger for [GpsController]
  final GpsDebugger _gpsDebugger;

  /// Accept options as a stream to allow changing it on the flight.
  final Stream<GpsOptions> _gpsOptions$;

  /// Keep reference to the latest [GpsOptions] from [_gpsOptions$] so that
  /// new stream could be built when debugger is turned on.
  GpsOptions _lastGpsOptions;

  /// Service

  @override
  Future<void> start() {
    super.start();

    // listen to the gpsOptions$ stream to create new gps stream with new options.
    final sub = _gpsOptions$.distinct().listen((gpsOptions) {
      _lastGpsOptions = gpsOptions;

      if (!_gpsDebugger.isOn.value) {
        _buildNewStream();
      }
    });

    disposer.autoDispose(sub);
    return null;
  }

  _buildNewStream() {
    // not rebuild if gps options are not available.
    if (_lastGpsOptions == null) return;

    final newStream = _gpsAdapter.buildStream(_lastGpsOptions);

    // sometimes adapter cannot build a stream due to lacking permission.
    if (newStream == null) return;

    // rebuilt the subscription to adapter's stream.
    _adapterSubscription?.cancel();
    _adapterSubscription = newStream.listen(_subject.add);

    disposer.autoDispose(_adapterSubscription);

    // debugger use the stream from service
    $switcher.add(_subject);

    Log.debug('GpsController built new stream with $_lastGpsOptions.');
  }

  /// An adapter that communicate with Location Service to determine the current
  /// location of device.
  final GpsAdapter _gpsAdapter;

  /// A subscription to stream provided by [_gpsAdapter]
  StreamSubscription<LatLng> _adapterSubscription;

  /// Backing field of [latLng$]
  Stream<LatLng> _latLng$;
}

abstract class GpsAdapter {
  /// Build new [latLng$] stream with the given [GpsOptions].
  /// Return null if cannot build stream.
  Stream<LatLng> buildStream(GpsOptions options);
}
