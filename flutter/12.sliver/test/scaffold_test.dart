import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Scaffold control test', (WidgetTester tester) async {
    final Key bodyKey = UniqueKey();
    Widget boilerplate(Widget child) {
      return Localizations(
        locale: const Locale('en', 'us'),
        delegates: const <LocalizationsDelegate<dynamic>>[
          DefaultWidgetsLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
        ],
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: child,
        ),
      );
    }

    await tester.pumpWidget(boilerplate(
      Scaffold(
        appBar: AppBar(title: const Text('Title')),
        body: Container(key: bodyKey),
      ),
    ));
    expect(tester.takeException(), isFlutterError);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Title')),
        body: Container(key: bodyKey),
      ),
    ));
    RenderBox bodyBox = tester.renderObject(find.byKey(bodyKey));
    expect(bodyBox.size, equals(const Size(800.0, 544.0)));

    await tester.pumpWidget(boilerplate(
      MediaQuery(
        data: const MediaQueryData(viewInsets: EdgeInsets.only(bottom: 100.0)),
        child: Scaffold(
          appBar: AppBar(title: const Text('Title')),
          body: Container(key: bodyKey),
        ),
      ),
    ));

    bodyBox = tester.renderObject(find.byKey(bodyKey));
    expect(bodyBox.size, equals(const Size(800.0, 444.0)));

    // Backwards compatibility: deprecated resizeToVoidBottomPadding flag
    await tester.pumpWidget(boilerplate(MediaQuery(
      data: const MediaQueryData(viewInsets: EdgeInsets.only(bottom: 100.0)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Title')),
        body: Container(key: bodyKey),
        resizeToAvoidBottomPadding: false,
      ),
    )));

    bodyBox = tester.renderObject(find.byKey(bodyKey));
    expect(bodyBox.size, equals(const Size(800.0, 544.0)));
  });

  testWidgets('Floating action button directionality',
      (WidgetTester tester) async {
    Widget build(TextDirection textDirection) {
      return Directionality(
        textDirection: textDirection,
        child: const MediaQuery(
          data: MediaQueryData(
            viewInsets: EdgeInsets.only(bottom: 200.0),
          ),
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: null,
              child: Text('1'),
            ),
          ),
        ),
      );
    }

    await tester.pumpWidget(build(TextDirection.ltr));

    expect(tester.getCenter(find.byType(FloatingActionButton)),
        const Offset(765.0, 356.0));

    await tester.pumpWidget(build(TextDirection.rtl));
    expect(tester.binding.transientCallbackCount, 0);

    expect(tester.getCenter(find.byType(FloatingActionButton)),
        const Offset(44.0, 356.0));
  });
}
