import 'dart:async';

import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/base/service.dart';

import 'face.dart';

abstract class GenderDetector implements Service {
  Future<PassengerGender> detect(Face face);
}

class GenderDetectorImpl with ServiceMixin implements GenderDetector {
  /// Dummy detection that recognize the gender based on photo's file path
  Future<PassengerGender> detect(Face face) async {
    if (face.photo.filePath.contains('female')) {
      return PassengerGender.female;
    }
    if (face.photo.filePath.contains('male')) {
      return PassengerGender.male;
    }
    return PassengerGender.unknown;
  }
}
