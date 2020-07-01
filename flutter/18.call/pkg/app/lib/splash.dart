import 'package:flutter/widgets.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 200,
          alignment: Alignment.center,
          decoration: const FlutterLogoDecoration(),
        )
      ],
    );
  }
}
