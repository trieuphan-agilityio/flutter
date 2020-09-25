import 'package:ad_bloc/model.dart';

abstract class GenderDetector {
  Future<PassengerGender> detect(Face face);
}

class FakeGenderDetector implements GenderDetector {
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
