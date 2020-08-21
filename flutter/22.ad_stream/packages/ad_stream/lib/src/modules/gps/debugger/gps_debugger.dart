import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/base/debugger.dart';
import 'package:rxdart/rxdart.dart';

abstract class GpsDebugger implements Debugger {
  Stream<LatLng> get latLng$;
}

class GpsDebuggerImpl with DebuggerMixin implements GpsDebugger {
  final BehaviorSubject<LatLng> _controller;

  GpsDebuggerImpl() : _controller = BehaviorSubject<LatLng>();

  Stream<LatLng> get latLng$ => _controller.stream;
}
