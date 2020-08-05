import 'package:ad_stream_app/src/features/ad_displaying/ad_displaying.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (_) => SplashScreen(),
      '/ad': (_) => AdDisplaying(),
    },
  ));
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
