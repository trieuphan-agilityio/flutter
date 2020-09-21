import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';
import 'package:ad_bloc/src/service/power_provider.dart';
import 'package:flutter/material.dart';

class PowerContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Power(
      appEventSink: AppBloc.of(context),
      powerProvider: Provider.of<PowerProvider>(context),
    );
  }
}

class _Power extends StatefulWidget {
  final EventSink<AppEvent> appEventSink;
  final PowerProvider powerProvider;

  const _Power(
      {Key key, @required this.appEventSink, @required this.powerProvider})
      : super(key: key);

  @override
  __PowerState createState() => __PowerState();
}

class __PowerState extends State<_Power> with AutoDisposeMixin {
  @override
  void initState() {
    final sub = widget.powerProvider.isStrong$.listen((isStrong) {
      widget.appEventSink.add(PowerChanged(isStrong));
    });
    autoDispose(sub);

    widget.powerProvider.start();

    super.initState();
  }

  @override
  void dispose() {
    widget.powerProvider.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
