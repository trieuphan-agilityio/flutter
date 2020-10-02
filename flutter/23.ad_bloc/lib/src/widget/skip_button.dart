import 'package:flutter/material.dart';

/// SkipButton displays a countdown corresponding to 'initial' value.
/// It invokes 'onSkip' function once user hits on the button.
class SkipButton extends StatefulWidget {
  final Function onSkip;

  /// Initial value of the countdown
  final int canSkipAfter;

  const SkipButton(
      {Key key, @required this.onSkip, @required this.canSkipAfter})
      : assert(canSkipAfter > 0),
        super(key: key);

  @override
  _SkipButtonState createState() => _SkipButtonState();
}

class _SkipButtonState extends State<SkipButton>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(seconds: widget.canSkipAfter),
      tween: IntTween(begin: 0, end: widget.canSkipAfter),
      builder: (context, value, child) {
        // ignore skip until counting to 0.
        final ignoreSkip = value != widget.canSkipAfter;

        // display the countdown number on ignoring
        final text = ignoreSkip ? widget.canSkipAfter - value : 'Skip Ad';

        return AbsorbPointer(
          absorbing: ignoreSkip,
          child: FlatButton(
            color: Theme.of(context).splashColor.withAlpha(150),
            onPressed: () => widget.onSkip(),
            child: Text('$text'),
          ),
        );
      },
    );
  }
}
