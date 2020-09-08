import 'dart:async';

import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/base/service.dart';

import 'face.dart';

abstract class GenderDetector implements Service {
  Future<PassengerGender> detect(Face face);
}

class GenderDetectorImpl with ServiceMixin implements GenderDetector {
  Future<PassengerGender> detect(Face faces) async {
    // FIXME
    return PassengerGender.male;
  }
}
