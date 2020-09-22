import 'dart:async';

import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/model.dart';

import '../debugger_factory.dart';
import '../service.dart';

abstract class GpsController implements Service {
  /// Provider a pair of Latitude & Longitude, is updated corresponding to
  /// the current Location of the device.
  Stream<LatLng> get latLng$;

  changeGpsOptions(GpsOptions options);
}

class GpsControllerImpl with ServiceMixin implements GpsController {
  GpsControllerImpl(this._gpsAdapter, {this.debugger})
      : controller = StreamController.broadcast();

  Stream<LatLng> get latLng$ => _latLng$ ??= controller.stream;

  final StreamController<LatLng> controller;
  final GpsDebugger debugger;

  /// Service

  @override
  start() async {
    super.start();
    if (debugger == null)
      _buildNewStream();
    else
      disposer.autoDispose(
        debugger.latLng$.listen(controller.add),
      );
  }

  GpsOptions _lastGpsOptions;

  /// React to the changed [GpsOptions] event.
  changeGpsOptions(GpsOptions options) {
    _lastGpsOptions = options;
    _buildNewStream();
  }

  _buildNewStream() async {
    // should wait for GpsOptions value on next event of the app
    if (_lastGpsOptions == null) return;

    final newStream = await _gpsAdapter.buildStream(_lastGpsOptions);

    // sometimes adapter cannot build a stream due to lacking permission.
    if (newStream == null) return;

    // rebuilt the subscription to adapter's stream.
    _adapterSubscription?.cancel();
    _adapterSubscription = newStream.listen(controller.add);

    disposer.autoDispose(_adapterSubscription);
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
  Future<Stream<LatLng>> buildStream(GpsOptions options);
}
