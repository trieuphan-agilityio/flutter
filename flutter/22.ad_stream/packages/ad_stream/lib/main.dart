import 'package:ad_stream/src/features/ad_displaying/ad_displaying.dart';
import 'package:ad_stream/src/modules/ad/ad_services.dart';
import 'package:ad_stream/src/modules/di/di.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

/// App initialise Dependency Injector
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DI>(
      future: _createDI(),
      builder: (_, snapshot) {
        if (snapshot.hasData)
          return buildWithDI(snapshot.data);
        else
          return buildSplash();
      },
    );
  }

  Widget buildSplash() {
    return SplashScreen();
  }

  Widget buildWithDI(DI di) {
    return MultiProvider(
      providers: [
        Provider<DI>(create: (_) => di),
      ],
      child: MaterialApp(
        routes: {
          '/': (_) => SplashScreen(),
          '/ad': (_) => AdDisplaying(),
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
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
            style: Theme.of(context).textTheme.headline1,
          ),
        ],
      ),
    );
  }
}

Future<DI> _createDI() {
  return DI.create(
    AdServices(),
  );
}
