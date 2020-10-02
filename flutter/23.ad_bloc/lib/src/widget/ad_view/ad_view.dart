import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';
import 'package:ad_bloc/model.dart';

import '../skip_button.dart';
import 'image_view.dart';
import 'video_view.dart';

class AdView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _AdView(adEventSink: AdBloc.of(context));
  }
}

class _AdView extends StatefulWidget {
  final EventSink<AdEvent> adEventSink;

  const _AdView({Key key, @required this.adEventSink}) : super(key: key);

  @override
  _AdViewState createState() => _AdViewState();
}

class _AdViewState extends State<_AdView> {
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
      listener: (context, state) {
        finishTimer?.cancel();
        // when timer elapsed, Ad impression can be finished.
        finishTimer = Timer(state.ad.duration, () {
          widget.adEventSink.add(const AdFinished());
        });
      },
      builder: (_, state) {
        final model = state.ad;
        return Stack(
          children: [
            AnimatedSwitcher(
              child: Container(
                key: Key('ad_view_${model.id}'),
                child: _buildView(context, model),
              ),
              duration: Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final offsetAnimation = Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset(0.0, 0.0),
                ).animate(animation);
                return SlideTransition(position: offsetAnimation, child: child);
              },
              // disable switch out transition
              switchOutCurve: const Threshold(0.0),
            ),
            _buildAdInfo(context, model),
            _buildSkipButton(model),
          ],
        );
      },
    );
  }

  Widget _buildSkipButton(AdViewModel model) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Align(
        child: model.isSkippable
            ? SkipButton(
                key: ValueKey('skip_button_${model.id}'),
                canSkipAfter: model.canSkipAfter,
                onSkip: _onSkip,
              )
            : SizedBox.shrink(),
        alignment: Alignment.bottomRight,
      ),
    );
  }

  _onSkip() {
    finishTimer?.cancel();
    finishTimer = null;
    widget.adEventSink.add(const AdSkipped());
  }

  Widget _buildView(BuildContext context, AdViewModel model) {
    if (model.type == CreativeType.screensaver) {
      return Placeholder();
    }

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
