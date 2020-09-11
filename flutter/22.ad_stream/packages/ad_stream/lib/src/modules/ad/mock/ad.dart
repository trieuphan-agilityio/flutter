import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';

final List<Ad> mockAds = [...randomAds];

final List<Ad> randomAds = [
  ...List<Ad>.generate(200, (_) => _generateAd()),
];

Ad _generateAd() {
  return Ad(
    id: faker.guid.guid(),
    creative: _generateCreative(),
    timeBlocks: faker.randomGenerator.integer(5, min: 1),
    canSkipAfter: 6,
    targetingKeywords: faker.lorem
        .words(faker.randomGenerator.integer(10, min: 5))
        .map((w) => Keyword(w))
        .toList(),
    targetingAreas: [const Area('Da Nang')],
    targetingGenders: _generateTargetingGenders(),
    targetingAgeRanges: _generateTargetingAgeRanges(),
    version: 0,
    createdAt: DateTime.now(),
    lastModifiedAt: DateTime.now(),
  );
}

Iterable<PassengerGender> _generateTargetingGenders() {
  // 20%
  final shouldReturnBothGenders = (faker.randomGenerator.integer(10) > 8);
  if (shouldReturnBothGenders) {
    return const [PassengerGender.female, PassengerGender.male];
  }
  // 40%
  final shouldReturnMale = faker.randomGenerator.boolean();
  if (shouldReturnMale) {
    return const [PassengerGender.male];
  }
  // 40%
  return const [PassengerGender.female];
}

Iterable<PassengerAgeRange> _generateTargetingAgeRanges() {
  /// 14% for each
  return [
    [
      const PassengerAgeRange(16, 25),
      const PassengerAgeRange(16, 60),
      const PassengerAgeRange(18, 48),
      const PassengerAgeRange(26, 30),
      const PassengerAgeRange(26, 48),
      const PassengerAgeRange(26, 60),
      const PassengerAgeRange(40, 60),
    ][faker.randomGenerator.integer(6)]
  ];
}

Creative _generateCreative() {
  // 80% image
  final shouldReturnImage = (faker.randomGenerator.integer(10) < 8);

  if (shouldReturnImage) {
    return faker.creative.image();
  } else {
    final shouldReturnVideo = faker.randomGenerator.boolean();
    // 10% that it's video
    if (shouldReturnVideo) {
      return faker.creative.video();
    } else if (faker.randomGenerator.boolean()) {
      // 5% youtube
      return faker.creative.youtube();
    } else {
      // 5% html
      return faker.creative.html();
    }
  }
}

Iterable<Ad> mockImageAds = [];
Iterable<Ad> mockVideoAds = [];
Iterable<Ad> mockHtmlAds = [];
Iterable<Ad> mockYoutubeAds = [];
