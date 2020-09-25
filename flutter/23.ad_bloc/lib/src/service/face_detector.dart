import 'dart:convert';

import 'package:ad_bloc/model.dart';
import 'package:crypto/crypto.dart';

abstract class FaceDetector {
  Future<Iterable<Face>> detect(Photo photo);
}

class FakeFaceDetector implements FaceDetector {
  Future<Iterable<Face>> detect(Photo photo) async {
    /// Dummy detection that recognize faces based on photo's file path
    Iterable<Face> faces;

    const femalePhoto = Photo('face-sample-female-26_30.png');
    const malePhoto = Photo('face-sample-male-18_25.png');

    if (photo.filePath.contains('sample_1')) {
      faces = [
        Face(_genFaceId(femalePhoto), femalePhoto),
        Face(_genFaceId(malePhoto), malePhoto),
      ];
    } else if (photo.filePath.contains('sample_2')) {
      faces = [
        Face(_genFaceId(femalePhoto), femalePhoto),
      ];
    } else if (photo.filePath.contains('sample_3')) {
      faces = [
        Face(_genFaceId(malePhoto), malePhoto),
      ];
    } else {
      faces = [];
    }

    return faces;
  }

  /// Create an unique face id for the given photo
  String _genFaceId(Photo photo) {
    /// make an unique string using photo's data
    return sha1.convert(utf8.encode(photo.filePath)).toString().substring(0, 5);
  }
}
