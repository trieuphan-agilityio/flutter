import 'dart:developer' as dartDev;

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/features/debugger/debug_button.dart';
import 'package:ad_stream/src/features/debugger/drawer.dart';
import 'package:ad_stream/src/features/display_ad/ad_view.dart';
import 'package:ad_stream/src/features/request_permission/permission_container.dart';
import 'package:ad_stream/src/modules/di/di.dart';
import 'package:ad_stream/src/modules/service_manager/service_manager_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  /// log to console
  Log.log$.listen(dartDev.log);

  runApp(App());
}

/// App initialise Dependency Injector
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppLifecycle(
      child: DIContainer(child: _buildApp(), splash: SplashScreen()),
    );
  }

  Widget _buildApp() {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Ad Stream')),
        drawer: DebugDrawer(),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              ServiceManagerContainer(),
              AdViewContainer(),
              PermissionContainer(),
              Align(child: DebugButton(), alignment: Alignment.bottomCenter),
            ],
          ),
        ),
      ),
    );
  }
}

/// Keep track the status of App's lifecycle
class AppLifecycle extends StatefulWidget {
  final Widget child;

  const AppLifecycle({Key key, @required this.child}) : super(key: key);

  @override
  _AppLifecycleState createState() => _AppLifecycleState();
}

class _AppLifecycleState extends State<AppLifecycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Log.info('AppLifecycle $state.');
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class DIContainer extends StatefulWidget {
  /// [child] widget is the main app that will be displayed when DI is ready.
  final Widget child;

  /// [splash] widget will be displayed while preparing the dependency tree.
  final Widget splash;

  const DIContainer({Key key, @required this.child, @required this.splash})
      : super(key: key);

  @override
  _DIContainerState createState() => _DIContainerState();
}

class _DIContainerState extends State<DIContainer> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DI>(
      future: createDI(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Provider<DI>.value(value: snapshot.data, child: widget.child);
        } else {
          return widget.splash;
        }
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: const Key('splash'),
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
