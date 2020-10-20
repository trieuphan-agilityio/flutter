import 'package:test/test.dart';

import 'util.dart';

main() {
  useDartfmt();
  group('generator', () {
    test('run with 2 text fields', () async {
      await runAndExpect(
        'generator_test_input.txt',
        'generator_test_output.txt',
        (String input, String output) async {
          final actual = await generate(input);
          expect(actual, output);
        },
      );
    });
  });
}
