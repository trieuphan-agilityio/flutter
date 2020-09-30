import 'package:ad_bloc/model.dart';
import 'package:faker/faker.dart';

import 'fake_creative.dart';

final List<Ad> fakeAds = [...randomAds];

final List<Ad> randomAds = [
  ...List<Ad>.generate(200, (_) => _generateAd()),
];

Ad _generateAd() {
  return Ad(
    id: faker.guid.guid(),
    creative: _generateCreative(),
    timeBlocks: faker.randomGenerator.integer(3, min: 1),
    canSkipAfter: _generateCanSkipAfter(),
    targetingKeywords: faker.lorem
        .words(faker.randomGenerator.integer(10, min: 5))
        .map((w) => Keyword(w))
        .toList(),
    targetingAreas: [const Area('Da Nang')],
    targetingGenders: _generateTargetingGenders(),
    targetingAgeRanges: _generateTargetingAgeRanges(),
    version: 0,
    createdAt: DateTime.now().millisecondsSinceEpoch,
    lastModifiedAt: DateTime.now().millisecondsSinceEpoch,
  );
}

int _generateCanSkipAfter() {
  // 80% ads can skip
  final canSkip = (faker.randomGenerator.integer(10) < 8);
  if (canSkip) {
    return 3;
  }
  return -1;
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
  // 40% image
  final shouldReturnImage = (faker.randomGenerator.integer(10) < 4);

  if (shouldReturnImage) {
    return faker.creative.image();
  } else {
    final shouldReturnVideo = (faker.randomGenerator.integer(10) < 7);
    // 40% that it's video
    if (shouldReturnVideo) {
      return faker.creative.video();
    } else if (faker.randomGenerator.boolean()) {
      // 10% youtube
      return faker.creative.youtube();
    } else {
      // 10% html
      return faker.creative.html();
    }
  }
}
