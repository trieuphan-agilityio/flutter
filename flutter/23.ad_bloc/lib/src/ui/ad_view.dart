import 'dart:async';
import 'dart:math';

import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'skip_button.dart';

class AdContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _AdController(adEventSink: AdBloc.of(context));
  }
}

class _AdController extends StatefulWidget {
  final EventSink<AdEvent> adEventSink;

  const _AdController({Key key, @required this.adEventSink}) : super(key: key);

  @override
  _AdControllerState createState() => _AdControllerState();
}

class _AdControllerState extends State<_AdController> {
  /// [finishTimer] fires when required time block of the Ad elapsed.
  Timer finishTimer;

  @override
  void initState() {
    widget.adEventSink.add(const AdStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdBloc, AdState>(
      // listenWhen: (previous, current) {
      //   return previous.ad != current.ad;
      // },
      listener: (context, state) {
        if (state.ad == null) return;

        finishTimer?.cancel();
        // when timer elapsed, Ad impression can be finished.
        finishTimer = Timer(state.ad.duration, () {
          widget.adEventSink.add(const AdFinished());
        });
      },
      // buildWhen: (previous, current) {
      //   return previous.ad != current.ad;
      // },
      builder: (_, state) {
        if (state.ad == null)
          return Placeholder(key: const Key('ad_view_placeholder'));

        return _AdView(
          key: const Key('ad_view'),
          model: state.ad,
          onSkip: () {
            finishTimer?.cancel();
            finishTimer = null;
            widget.adEventSink.add(const AdSkipped());
          },
        );
      },
    );
  }
}

class _AdView extends StatelessWidget {
  final AdViewModel model;
  final Function onSkip;

  const _AdView({Key key, @required this.model, @required this.onSkip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              _buildAdInfo(context, model),
              _buildSkipButton(model),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton(AdViewModel model) {
    return Padding(
      key: ValueKey('skip_button_${model.ad.shortId}'),
      padding: EdgeInsets.all(20),
      child: Align(
        child: model.isSkippable
            ? SkipButton(canSkipAfter: model.canSkipAfter, onSkip: onSkip)
            : SizedBox.shrink(),
        alignment: Alignment.bottomRight,
      ),
    );
  }

  Widget _buildAdInfo(BuildContext context, AdViewModel model) {
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
}

Color _chooseColorForAd() {
  return _kAdInfoBgColors[_random.nextInt(_kAdInfoBgColors.length - 1)];
}

final Random _random = Random();

final List<Color> _kAdInfoBgColors = [
  SolarizedColor.yellow.withAlpha(100),
  SolarizedColor.orange.withAlpha(100),
  SolarizedColor.red.withAlpha(100),
  SolarizedColor.magenta.withAlpha(100),
  SolarizedColor.violet.withAlpha(100),
  SolarizedColor.blue.withAlpha(100),
  SolarizedColor.cyan.withAlpha(100),
  SolarizedColor.green.withAlpha(100),
];
