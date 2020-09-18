import 'package:faker/faker.dart';

extension UrlPathFaker on Faker {
  _UrlPath get urlPath => _UrlPath();
}

const String _kUrlPathPrefix = '/faker';

class _UrlPath {
  String get image {
    final imageName = faker.lorem.words(5).join('_');
    final imageFileName = '$imageName.jpg';
    return '$_kUrlPathPrefix/$imageFileName';
  }

  String get video {
    final videoName = faker.lorem.words(5).join('_');
    final videoFileName = '$videoName.mp4';
    return '$_kUrlPathPrefix/$videoFileName';
  }

  String get html {
    final htmlName = faker.lorem.words(5).join('_');
    final htmlFileName = '$htmlName.zip';
    return '$_kUrlPathPrefix/$htmlFileName';
  }

  String get youtube {
    final videoId = faker.randomGenerator.fromPatternToHex(['#_#########']);
    final baseUrl = 'https://youtu.be';
    return '$baseUrl/$videoId';
  }
}
