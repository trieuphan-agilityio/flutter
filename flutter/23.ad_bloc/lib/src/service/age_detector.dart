import 'package:ad_bloc/model.dart';

abstract class AgeDetector {
  Future<PassengerAgeRange> detect(Face face);
}

class FakeAgeDetector implements AgeDetector {
  /// Dummy detection that recognize the age range based on photo's file path
  Future<PassengerAgeRange> detect(Face face) async {
    if (face.photo.filePath.contains('18_25')) {
      return const PassengerAgeRange(18, 25);
    }
    if (face.photo.filePath.contains('26_30')) {
      return const PassengerAgeRange(26, 30);
    }
    return const PassengerAgeRange(18, 40);
  }
}
