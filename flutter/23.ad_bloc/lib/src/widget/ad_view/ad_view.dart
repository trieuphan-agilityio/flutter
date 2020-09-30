import 'dart:async';

import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';
import 'package:ad_bloc/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../skip_button.dart';
import 'image_view.dart';
import 'video_view.dart';

class AdView extends StatelessWidget {
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
  Widget previousAdView;

  @override
  void initState() {
    previousAdView = Container();
    widget.adEventSink.add(const AdStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdBloc, AdState>(
      listener: (context, state) {
        if (state.ad == null) return;

        finishTimer?.cancel();
        // when timer elapsed, Ad impression can be finished.
        finishTimer = Timer(state.ad.duration, () {
          widget.adEventSink.add(const AdFinished());
        });
      },
      builder: (_, state) {
        if (state.ad == null) {
          return Container(key: const Key('ad_view_placeholder'));
        }

        final model = state.ad;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _AdView(
            key: Key('ad_view_${model.id}'),
            model: model,
            onSkip: () {
              finishTimer?.cancel();
              finishTimer = null;
              widget.adEventSink.add(const AdSkipped());
            },
          ),
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
              _buildView(context, model),
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
      key: ValueKey('skip_button_${model.id}'),
      padding: EdgeInsets.all(20),
      child: Align(
        child: model.isSkippable
            ? SkipButton(canSkipAfter: model.canSkipAfter, onSkip: onSkip)
            : SizedBox.shrink(),
        alignment: Alignment.bottomRight,
      ),
    );
  }

  Widget _buildView(BuildContext context, AdViewModel model) {
    if (model.type == CreativeType.image) {
      return ImageView(model: model);
    }

    if (model.type == CreativeType.video) {
      return VideoView(model: model);
    }

    return Container();
  }

  Widget _buildAdInfo(BuildContext context, AdViewModel model) {
    return Container(
      height: 50,
      padding: EdgeInsets.all(8),
      child: Stack(children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${model.id}'
                  ', ${model.type.name}'
                  ', ${model.duration.inSeconds}s'
                  ', skip after: ${model.canSkipAfter}'),
            ],
          ),
          color: Colors.white,
          padding: EdgeInsets.all(8),
          alignment: Alignment.topLeft,
        ),
      ]),
    );
  }
}
