import 'package:ad_stream/models.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Creative', () {
    test('can compare with other', () {
      final sample1 = ImageCreative(
        id: '18e8ac00-c533-185b-4c55-e90e51384fb1',
        urlPath: '/faker/vestibulum_leo_quam_mi_pellentesque.jpg',
        filePath: null,
      );
      final sample2 = ImageCreative(
        id: 'f9f3ce57-5c72-36d0-2960-e218eeee1e89',
        urlPath: '/faker/dictum_nascetur_dictum_amet_iaculis.jpg',
        filePath: null,
      );

      final sample1Cloned = sample1.copyWith();
      expect(sample1 == sample1Cloned, equals(true));
      expect(sample1 == sample2, equals(false));
    });
  });
}
