import 'package:ad_bloc/bloc.dart';
import 'package:ad_bloc/src/widget/ad_view/video_view.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('VideoView', () {
    testWidgets('can play', (tester) async {
      await tester.pumpWidget(
        VideoView(
          model: AdViewModel()
            ..id = 'test'
            ..duration = Duration(seconds: 5)
            ..isSkippable = false
            ..canSkipAfter = 6
            ..filePath = 'assets/v0.mp4',
        ),
      );
    });
  });
}
