import 'package:ad_stream/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Ad Module can start', (WidgetTester tester) async {
    await tester.pumpWidget(App());

    expect(find.byKey(const Key('splash')), findsOneWidget);
    await tester.pump(Duration(seconds: 10));

    expect(find.byKey(const Key('ad_view_placeholder')), findsOneWidget);

    await tester.pump(Duration(seconds: 30));
    expect(find.byKey(const Key('ad_view')), findsOneWidget);
  });
}
