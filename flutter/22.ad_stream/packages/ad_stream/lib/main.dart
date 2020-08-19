import 'dart:developer' as dart_dev;

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/features/ad_displaying/ad_view.dart';
import 'package:ad_stream/src/features/debugger/debug_button.dart';
import 'package:ad_stream/src/features/debugger/drawer.dart';
import 'package:ad_stream/src/modules/di/di.dart';
import 'package:ad_stream/src/modules/permission/permission_container.dart';
import 'package:ad_stream/src/modules/service_manager/service_manager_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Asynchronously create Dependency Injection tree.
/// While the object is constructing the app will display [Splash] screen.
Future<DI> _diFuture = Future(createDI);

void main() {
  /// log to console
  Log.log$.listen(dart_dev.log);

  runApp(App());
}

/// App initialise Dependency Injector
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DI>(
      future: _diFuture,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return buildWithDI(context, snapshot.data);
        } else {
          return SplashScreen();
        }
      },
    );
  }

  Widget buildWithDI(BuildContext context, DI di) {
    return Provider.value(
      value: di,
      child: MaterialApp(
        home: Scaffold(
          drawer: DebugDrawer(),
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                ServiceManagerContainer(child: AdViewContainer()),
                PermissionContainer(),
                Align(child: DebugButton(), alignment: Alignment.bottomCenter),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: FlutterLogoDecoration(),
            ),
            SizedBox(height: 20),
            Text(
              'Ad Stream Practice',
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
    );
  }
}
