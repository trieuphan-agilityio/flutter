import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';
import 'constants.dart';
import 'data/gallery_options.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const App());
}

class App extends StatelessWidget {
  const App({
    Key key,
    this.isTestMode = false,
  }) : super(key: key);

  final bool isTestMode;

  @override
  Widget build(BuildContext context) {
    return ModelBinding(
      initialModel: GalleryOptions(
        themeMode: ThemeMode.system,
        textScaleFactor: systemTextScaleFactorOption,
        customTextDirection: CustomTextDirection.localeBased,
        locale: null,
        timeDilation: timeDilation,
        platform: defaultTargetPlatform,
        isTestMode: isTestMode,
      ),
      child: const ShrineApp(),
    );
  }
}
