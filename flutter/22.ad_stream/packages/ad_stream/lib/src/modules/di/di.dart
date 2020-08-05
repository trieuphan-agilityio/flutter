import 'package:ad_stream/src/modules/ad/ad_services.dart';
import 'package:flutter/widgets.dart';
import 'package:inject/inject.dart';
import 'package:provider/provider.dart';

import 'di.inject.dart' as g;

@Injector(const [AdServices])
abstract class DI implements AdServiceLocator {
  static DI of(BuildContext context) {
    return Provider.of<DI>(context);
  }

  /// Boilerplate code to wire things together.
  static Future<DI> create(
    AdServices adModule,
  ) async {
    final services = await g.DI$Injector.create(
      adModule,
    );
    return services;
  }
}
