import 'package:device_preview/device_preview.dart';
import 'package:flutter/widgets.dart';
import 'package:mex/main.dart' as mex;

main() async {
  final services = await mex.createServices();
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => mex.App(services),
    ),
  );
}
