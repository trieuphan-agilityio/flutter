import 'dart:async';
import 'dart:math';

import 'package:ad_stream/src/base/color.dart';
import 'package:ad_stream/src/features/display_ad/skip_button.dart';
import 'package:ad_stream/src/modules/ad/ad_presenter.dart';
import 'package:ad_stream/src/modules/di/di.dart';
import 'package:flutter/material.dart';

class AdViewContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdViewImpl(presenter: DI.of(context).adPresenter);
  }
}

class AdViewImpl extends StatefulWidget {
  final AdPresenter presenter;

  const AdViewImpl({Key key, this.presenter}) : super(key: key);

  @override
  _AdViewImplState createState() => _AdViewImplState();
}

class _AdViewImplState extends State<AdViewImpl> implements AdView {
  DisplayableCreative model;

  /// [finishTimer] fires when required time block of the Ad elapsed.
  Timer finishTimer;

  @override
  void initState() {
    super.initState();
    widget.presenter.attach(this);
  }

  @override
  void dispose() {
    widget.presenter.detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// no display
    if (model == null) return Placeholder(key: Key('ad_view_placeholder'));

    return Container(
      key: Key('ad_view'),
      child: Stack(
        children: [
          _buildAdInfo(),
          _buildSkipButton(),
        ],
      ),
    );
  }

  Widget _buildSkipButton() {
    return Align(
      child: model.isSkippable
          ? SkipButton(canSkipAfter: model.canSkipAfter, onSkip: _skip)
          : SizedBox.shrink(),
      alignment: Alignment.bottomRight,
    );
  }

  Widget _buildAdInfo() {
    return Container(
      width: 400,
      height: 250,
      padding: EdgeInsets.all(16),
      child: Stack(children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model.ad.creative.shortId}',
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 8),
              Text('${model.wellFormatString}'),
            ],
          ),
          padding: EdgeInsets.all(16),
          color: _chooseColorForAd(),
          alignment: Alignment.topLeft,
        ),
      ]),
    );
  }

  /*
  Align(child: _buildDebugCountdown(), alignment: Alignment.bottomRight),
  Widget _buildDebugCountdown() {
    return finishTimer == null
        ? SizedBox.shrink()
        : Padding(
            child: Text('${model.duration.inSeconds - finishTimer.tick}s'),
            padding: EdgeInsets.all(8),
          );
  }
  */

  _skip() {
    finishTimer?.cancel();
    finishTimer = null;
    widget.presenter.skip();
  }

  display(DisplayableCreative model) {
    setState(() {
      this.model = model;

      if (model != null) {
        // when timer elapsed, Ad impression can be finished.
        finishTimer = Timer(model.duration, () {
          widget.presenter.finish();
        });
      }
    });
  }

  Color _chooseColorForAd() {
    return _adInfoBgColors[_random.nextInt(_adInfoBgColors.length - 1)];
  }

  Random _random = Random();

  List<Color> _adInfoBgColors = [
    SolarizedColor.yellow.withAlpha(100),
    SolarizedColor.orange.withAlpha(100),
    SolarizedColor.red.withAlpha(100),
    SolarizedColor.magenta.withAlpha(100),
    SolarizedColor.violet.withAlpha(100),
    SolarizedColor.blue.withAlpha(100),
    SolarizedColor.cyan.withAlpha(100),
    SolarizedColor.green.withAlpha(100),
  ];
}
