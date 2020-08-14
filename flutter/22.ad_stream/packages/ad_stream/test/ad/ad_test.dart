import 'package:ad_stream/models.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Ad', () {
    test('can compare with other', () {
      final ad = Ad(
          id: 'cf135d3a-4d95-6d0e-e904-48349e9e8c67',
          creative: VideoCreative(
              id: '8d3b4e94-c27f-c4fe-9f31-75a69f45bee4',
              urlPath: '/faker/nulla_vivamus_dictum_suspendisse_aliquet.mp4',
              filePath: null,
              format: 'mp4',
              videoLength: 34,
              fileSize: 106722),
          timeBlocks: 1,
          canSkipAfter: 6,
          targetingKeywords: [Keyword('varius')],
          targetingAreas: [Area('Da Nang')],
          version: 0,
          createdAt: DateTime.parse('2020-08-13 09:34:10.007672'),
          lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.007687'));

      final thatAd = ad.copyWith();
      expect(ad == thatAd, equals(true));

      final otherAd = ad.copyWith(version: ad.version + 1);
      expect(ad == otherAd, equals(false));
    });
  });
}
