import 'package:ad_stream/src/features/ad_displaying/ad_presenter.dart';
import 'package:ad_stream/src/modules/di/di.dart';
import 'package:flutter/material.dart';

class AdDisplaying extends StatelessWidget {
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
  DisplayableCreative model;

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
    return Container(
      child: Stack(
        children: [
          model.isSkippable
              ? SkipButton(
                  canSkipAfter: model.canSkipAfter,
                  onSkip: () => widget.presenter.skip(model.ad),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }

  @override
  display(DisplayableCreative model) {
    setState(() => this.model = model);
  }
}

/// SkipButton displays a countdown corresponding to 'initial' value.
/// It invokes 'onSkip' function once user hits on the button.
class SkipButton extends StatefulWidget {
  final Function onSkip;

  /// Initial value of the countdown
  final int canSkipAfter;

  const SkipButton({Key key, this.onSkip, this.canSkipAfter}) : super(key: key);

  @override
  _SkipButtonState createState() => _SkipButtonState();
}

class _SkipButtonState extends State<SkipButton>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(seconds: 1),
      tween: Tween<int>(begin: 0, end: widget.canSkipAfter),
      builder: (context, value, child) {
        // ignore skip until counting to 0.
        final ignoreSkip = value != widget.canSkipAfter;

        // display the countdown number on ignoring
        final text = ignoreSkip ? widget.canSkipAfter - value : 'Skip Ad';

        return AbsorbPointer(
          absorbing: ignoreSkip,
          child: FlatButton(
            onPressed: () => widget.onSkip(),
            child: Text('$text'),
          ),
        );
      },
    );
  }
}
