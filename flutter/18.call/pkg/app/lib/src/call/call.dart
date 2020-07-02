import 'dart:ui';

import 'package:app/core.dart';
import 'package:app/model.dart' as Model;
import 'package:app/src/app_services/app_services.dart';

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
  final Model.CallOptions callOptions;

  const Call({
    Key key,
    @required this.api,
    @required this.callOptions,
  }) : super(key: key);

  @override
  _CallState createState() => _CallState();
}

class _CallState extends State<Call> implements CallUI {
  @override
  void initState() {
    super.initState();
    widget.api.call(callOptions: widget.callOptions);
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

  @override
  List<Widget> buildBottomActions() {
    return [
      FlatButton(
        onPressed: () {},
        child: Icon(Icons.volume_down),
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
