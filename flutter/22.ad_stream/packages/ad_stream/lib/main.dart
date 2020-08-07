import 'package:ad_stream/src/features/ad_displaying/ad_view.dart';
import 'package:ad_stream/src/modules/debugger/debug_drawer.dart';
import 'package:ad_stream/src/modules/di/di.dart';
import 'package:ad_stream/src/modules/permission/permission_container.dart';
import 'package:ad_stream/src/modules/service_manager/service_manager_container.dart';
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
              body: Stack(children: <Widget>[
                Expanded(
                    child: ServiceManagerContainer(child: AdViewContainer())),
                PermissionContainer(),
              ]),
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
