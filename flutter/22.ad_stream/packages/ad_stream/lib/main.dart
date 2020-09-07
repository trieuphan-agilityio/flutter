import 'dart:developer' as dartDev;

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/features/debugger/debug_button.dart';
import 'package:ad_stream/src/features/display_ad/ad_view.dart';
import 'package:ad_stream/src/features/request_permission/permission_container.dart';
import 'package:ad_stream/src/modules/di/di.dart';
import 'package:ad_stream/src/modules/service_manager/service_manager_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config.dart';

void main() {
  /// log to console
  Log.log$.listen(dartDev.log);

  runApp(App());
}

void mainInjectConfig(Config config) {
  runApp(App(defaultConfig: config));
}

/// App initialise Dependency Injector
class App extends StatelessWidget {
  final Config defaultConfig;

  const App({Key key, this.defaultConfig}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppLifecycle(
      child: DIContainer(
        child: _buildApp(),
      ),
    );
  }

  Widget _buildApp() {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              if (defaultConfig != null) ConfigInjector(config: defaultConfig),
              ServiceManagerContainer(),
              AdViewContainer(),
              PermissionContainer(),
            ],
          ),
        ),
        floatingActionButton: DebugButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

  const DIContainer({Key key, @required this.child}) : super(key: key);

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
          return SplashScreen();
        }
      },
    );
  }
}

class ConfigInjector extends StatelessWidget {
  final Config config;
  const ConfigInjector({Key key, @required this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DI.of(context).configProvider.config = config;
    return SizedBox.shrink();
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
