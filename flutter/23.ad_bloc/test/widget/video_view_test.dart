import 'package:ad_bloc/bloc.dart';
import 'package:ad_bloc/src/widget/ad_view/video_view.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils.dart';

main() {
  group('VideoView', () {
    testWidgets('can play', (tester) async {
      await tester.pumpWidget(
        VideoView(
          model: AdViewModel.fromAd(
            sampleAds[2],
            sampleConfig.toAdConfig(),
          ),
        ),
      );
    });
  });
}
