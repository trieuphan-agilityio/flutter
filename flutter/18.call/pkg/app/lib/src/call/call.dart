import 'dart:async';
import 'dart:ui';

import 'package:app/app_services.dart';
import 'package:app/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'call_bloc.dart';

class _UX {
  static const double bottomBarPadding = 50.0;
  static const double avatarTopPadding = 60.0;
  static const double bottomBarSpacing = 20.0;
  static const double backdropBlurSigma = 6.0;
  static const double backdropDarknessOpacity = 0.5;
}

abstract class CallUI {
  Widget buildBackdrop();
  Widget buildTopLeftAction();
  Widget buildTopRightAction();
  List<Widget> buildBottomActions();

  onCallEndButtonPressed();
}

class Call extends StatefulWidget {
  final VideoCallApi api;

  const Call({Key key, @required this.api}) : super(key: key);

  @override
  _CallState createState() => _CallState();
}

class _CallState extends State<Call> implements CallUI {
  List<StreamSubscription> streamSubscriptions;

  @override
  void initState() {
    super.initState();

    streamSubscriptions = [];

    streamSubscriptions.add(
      widget.api.callDidFailToStartStream.listen((event) {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Couldn\'t Make Call'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ok'),
              )
            ],
          ),
        );
      }),
    );

    streamSubscriptions.add(
      widget.api.callDidStartStream.listen((event) {}),
    );
  }

  @override
  void dispose() {
    streamSubscriptions.forEach((subscription) {
      return subscription.cancel();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          buildBackdrop(),
          Theme(
            data: ThemeData.dark(),
            child: Builder(
              builder: (BuildContext context) {
                final theme = Theme.of(context);
                return SafeArea(
                  bottom: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(children: <Widget>[
                        buildTopLeftAction(),
                        const Spacer(),
                        buildTopRightAction(),
                      ]),
                      const SizedBox(height: _UX.avatarTopPadding),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('Jamie Larson',
                              style: theme.textTheme.headline4),
                          const SizedBox(height: 8),
                          buildCallStatus(context),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        child: Row(
                          children: <Widget>[
                            const Spacer(),
                            ...WidgetUtils.join(
                              buildBottomActions(),
                              const SizedBox(width: _UX.bottomBarSpacing),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      const SizedBox(height: _UX.bottomBarPadding),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  BlocBuilder<CallBloc, CallState> buildCallStatus(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<CallBloc>(context),
      builder: (context, CallState state) {
        final textStyle = Theme.of(context).textTheme.caption;
        if (state is Calling) {
          return Text(state.durationSecs.toString(), style: textStyle);
        }
        return Text('Ringing...', style: textStyle);
      },
    );
  }

  @override
  List<Widget> buildBottomActions() {
    return [
      FlatButton(
        onPressed: () {
          widget.api.endCall();
        },
        child: Icon(Icons.stop),
      ),
      FlatButton(
        onPressed: onCallEndButtonPressed,
        child: Icon(Icons.call_end),
      ),
    ];
  }

  @override
  Widget buildTopLeftAction() {
    return FlatButton(onPressed: () {}, child: Icon(Icons.chat_bubble));
  }

  @override
  Widget buildTopRightAction() {
    return SizedBox.shrink();
  }

  @override
  Widget buildBackdrop() {
    return RepaintBoundary(
      child: Stack(
        children: <Widget>[
          Container(decoration: const FlutterLogoDecoration()),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: _UX.backdropBlurSigma,
              sigmaY: _UX.backdropBlurSigma,
            ),
            child: Container(
                color: Colors.black.withOpacity(_UX.backdropDarknessOpacity)),
          ),
        ],
      ),
    );
  }

  @override
  onCallEndButtonPressed() {
    Navigator.pop(context);
  }
}
