import 'package:ad_bloc/base.dart';
import 'package:flutter/material.dart';

const kBootstrapTimeoutSecs = 5;

class Bootstrap extends StatelessWidget {
  /// Name of route that will be pushed after splash screen is finished.
  final String nextRouteName;

  const Bootstrap({Key key, @required this.nextRouteName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Bootstrap(
      nextRouteName: nextRouteName,
    );
  }
}

class _Bootstrap extends StatefulWidget {
  final String nextRouteName;

  const _Bootstrap({Key key, @required this.nextRouteName}) : super(key: key);

  @override
  _BootstrapState createState() => _BootstrapState();
}

class _BootstrapState extends State<_Bootstrap> with AutoDisposeMixin {
  Completer completer;
  Timer timeoutTimer;

  @override
  void initState() {
    completer = Completer<void>();

    // (!) do stuff here to bootstrap the application.
    // e.g download remote config, etc.
    Future.delayed(Duration(seconds: 1), () {
      completer.complete();
    });

    timeoutTimer = Timer(Duration(seconds: kBootstrapTimeoutSecs), () {
      if (!completer.isCompleted) {
        completer.completeError('bootstrap timeout!');
      }
    });

    completer.future.whenComplete(() {
      return Navigator.of(context).pushReplacementNamed(widget.nextRouteName);
    });

    super.initState();
  }

  @override
  void dispose() {
    timeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: const Key('bootstrap'),
      home: Scaffold(
        body: Container(
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
                'Ad Bloc',
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
