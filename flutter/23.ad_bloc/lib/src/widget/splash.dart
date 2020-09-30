import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/config.dart';
import 'package:ad_bloc/src/service/ad_repository/creative_downloader.dart';
import 'package:flutter/material.dart';

const kSplashTimeoutSecs = 5;

class Splash extends StatelessWidget {
  /// Widget that will be displayed after splash screen is finished.
  final Widget child;

  const Splash({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Splash(
      child: child,
      creativeDownloader: Provider.of<CreativeDownloader>(context),
      configProvider: Provider.of<ConfigProvider>(context),
    );
  }
}

class _Splash extends StatefulWidget {
  final Widget child;
  final CreativeDownloader creativeDownloader;
  final ConfigProvider configProvider;

  const _Splash({
    Key key,
    @required this.child,
    @required this.creativeDownloader,
    @required this.configProvider,
  }) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<_Splash> with AutoDisposeMixin {
  Completer completer;
  Timer timer;

  @override
  void initState() {
    final defaultAd = widget.configProvider.adConfig.defaultAd;
    completer = Completer<void>();

    autoDispose(
      widget.creativeDownloader.downloaded$.listen((downloadedCreative) {
        if (!completer.isCompleted) {
          widget.configProvider.config = widget.configProvider.config.copyWith(
            defaultAd: defaultAd.copyWith(creative: downloadedCreative),
          );
          completer.complete();
        }
      }),
    );

    // download default Ad
    widget.creativeDownloader.download(defaultAd.creative);

    timer = Timer(Duration(seconds: kSplashTimeoutSecs), () {
      if (!completer.isCompleted) {
        completer.completeError('bootstrap timeout!');
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: completer.future,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return widget.child;
        } else {
          return _buildSplash();
        }
      },
    );
  }

  _buildSplash() {
    return MaterialApp(
      key: const Key('splash'),
      home: Scaffold(
        body: Column(
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
    );
  }
}
