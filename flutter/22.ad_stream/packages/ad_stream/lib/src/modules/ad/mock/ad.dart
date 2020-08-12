import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';

final List<Ad> mockAds = [
  ...List<Ad>.generate(
      100,
      (_) => Ad(
            id: faker.guid.guid(),
            creative: faker.creative.html(),
            timeBlocks: faker.randomGenerator.integer(5, min: 1),
            canSkipAfter: 6,
            targetingKeywords: faker.lorem
                .words(faker.randomGenerator.integer(10, min: 5))
                .map((w) => Keyword(w))
                .toList(),
            targetingAreas: [const Area('Da Nang')],
            version: 0,
            createdAt: DateTime.now(),
            lastModifiedAt: DateTime.now(),
          )),
];
