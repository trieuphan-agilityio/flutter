import 'dart:async';

import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/on_trip/face_detector.dart';

abstract class AgeDetector {
  Future<PassengerAgeRange> detect(Face face);
}

class AgeDetectorImpl implements AgeDetector {
  Future<PassengerAgeRange> detect(Face face) async {
    // FIXME
    return PassengerAgeRange(18, 40);
  }
}
