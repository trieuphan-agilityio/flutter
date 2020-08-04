import 'package:ad_stream/ad_stream.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (_) => SplashScreen(),
      '/ad': (_) => AdScreen(),
    },
  ));
}

class AdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdViewerUI(presenter: DI.of(context).adPresenter);
  }
}

class AdViewerUI extends StatefulWidget {
  final AdPresentable presenter;

  const AdViewerUI({Key key, this.presenter}) : super(key: key);

  @override
  _AdViewerUIState createState() => _AdViewerUIState();
}

class _AdViewerUIState extends State<AdViewerUI> implements AdViewable {
  Ad ad;

  @override
  void initState() {
    widget.presenter.attach(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void dispose() {
    widget.presenter.detach();
    super.dispose();
  }

  @override
  displayAd(Ad ad) {
    setState(() => this.ad = ad);
  }

  @override
  hideSkipButton() {}

  @override
  showSkipButton() {}

  @override
  showSkipButtonOnCountDown(int remainingInSecs) {}
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

/// To pass compiler for now, it supposes to use inject.dart package.
class DI {
  static DI of(BuildContext context) {
    return Provider.of<DI>(context);
  }

  AdScheduler get adScheduler => AdSchedulerImpl(creativeRepository);

  AdRepository get creativeRepository => AdRepositoryImpl();

  AdPresentable get adPresenter {
    return AdPresenterImpl(adScheduler);
  }
}
