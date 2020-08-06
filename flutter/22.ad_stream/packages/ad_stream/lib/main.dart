import 'package:ad_stream/src/features/ad_displaying/ad_displaying.dart';
import 'package:ad_stream/src/modules/debugger/debug_drawer.dart';
import 'package:ad_stream/src/modules/di/di.dart';
import 'package:ad_stream/src/modules/supervisor/supervisor_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<DI> _diFuture = createDI();

void main() {
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
          return buildWithDI(snapshot.data);
        } else {
          return SplashScreen();
        }
      },
    );
  }

  Widget buildWithDI(DI di) {
    return Provider.value(
      value: di,
      child: MaterialApp(
        routes: {
          '/': (_) {
            return Scaffold(
              drawer: DebugDrawer(),
              body: SupervisorContainer(child: AdViewContainer()),
            );
          },
        },
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
              style: Theme.of(context).textTheme.headline3,
            ),
          ],
        ),
      ),
    );
  }
}
