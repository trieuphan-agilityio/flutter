import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:faker/faker.dart';

extension CreativeFakerExtension on Faker {
  CreativeFaker get creative => CreativeFaker();
}

class CreativeFaker {
  final faker = Faker();
  ImageCreative image() {
    return ImageCreative(
      id: faker.guid.guid(),
      urlPath: faker.urlPath.image,
      filePath: null,
    );
  }

  VideoCreative video() {
    return VideoCreative(
      id: faker.guid.guid(),
      urlPath: faker.urlPath.video,
      filePath: null,
      format: 'mp4',
      videoLength: faker.randomGenerator.integer(40, min: 15),
      fileSize: faker.randomGenerator.integer(400000, min: 10000),
    );
  }

  HtmlCreative html() {
    return HtmlCreative(
      id: faker.guid.guid(),
      urlPath: faker.urlPath.html,
      filePath: null,
      fileSize: faker.randomGenerator.integer(60000, min: 1),
    );
  }

  YoutubeCreative youtube() {
    return YoutubeCreative(
      id: faker.guid.guid(),
      urlPath: faker.urlPath.youtube,
      videoLength: faker.randomGenerator.integer(40, min: 15),
    );
  }
}
