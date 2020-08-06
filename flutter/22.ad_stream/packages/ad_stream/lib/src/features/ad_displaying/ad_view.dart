import 'package:ad_stream/src/features/ad_displaying/ad_presenter.dart';
import 'package:ad_stream/src/features/ad_displaying/skip_button.dart';
import 'package:ad_stream/src/modules/di/di.dart';
import 'package:flutter/material.dart';

class AdViewContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdView(presenter: DI.of(context).adPresenter);
  }
}

///
class AdView extends StatefulWidget {
  final AdPresentable presenter;

  const AdView({Key key, this.presenter}) : super(key: key);

  @override
  _AdViewState createState() => _AdViewState();
}

class _AdViewState extends State<AdView> implements AdViewable {
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
    /// no display
    if (model == null) return Placeholder();

    return Container(
      child: Stack(
        children: [
          _buildSkipButton(),
        ],
      ),
    );
  }

  Widget _buildSkipButton() {
    return model.isSkippable
        ? SkipButton(
            canSkipAfter: model.canSkipAfter,
            onSkip: () => widget.presenter.skip(model.ad),
          )
        : SizedBox.shrink();
  }

  @override
  display(DisplayableCreative model) {
    setState(() => this.model = model);
  }
}
