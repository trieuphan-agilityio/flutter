import 'dart:async';

import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/on_trip/face_detector.dart';
import 'package:rxdart/rxdart.dart';

abstract class AgeDetector {
  Stream<PassengerAgeRange> get age$;
}

class AgeDetectorImpl implements AgeDetector {
  final StreamController<PassengerAgeRange> controller;
  final Stream<List<Face>> faces$;

  AgeDetectorImpl(this.faces$)
      : controller = BehaviorSubject<PassengerAgeRange>();

  Stream<PassengerAgeRange> get age$ => controller.stream;
}
