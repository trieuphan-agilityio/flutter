import 'dart:async';

import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/on_trip/face_detector.dart';
import 'package:rxdart/subjects.dart';

abstract class GenderDetector {
  Stream<PassengerGender> get gender$;
}

class GenderDetectorImpl implements GenderDetector {
  final StreamController<PassengerGender> _controller;
  final Stream<List<Face>> faces$;

  GenderDetectorImpl(this.faces$)
      : _controller = BehaviorSubject<PassengerGender>();

  Stream<PassengerGender> get gender$ => _controller.stream;
}
