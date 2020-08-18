import 'dart:async';

import 'package:ad_stream/models.dart';
import 'package:rxdart/rxdart.dart';

abstract class AreaDetector {
  Stream<List<Area>> get areas$;
}

class AreaDetectorImpl implements AreaDetector {
  final StreamController<List<Area>> _controller;
  final Stream<LatLng> latLng$;

  AreaDetectorImpl(this.latLng$) : _controller = BehaviorSubject<List<Area>>();

  Stream<List<Area>> get areas$ => _controller.stream;
}
