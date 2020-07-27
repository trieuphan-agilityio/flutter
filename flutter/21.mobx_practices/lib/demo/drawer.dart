import 'package:flutter/material.dart';
import 'package:mobx_practices/demo/01_counter/counter_widget.dart';
import 'package:mobx_practices/demo/02_clock/clock.dart';
import 'package:mobx_practices/demo/03_connectivity/connectivity.dart';
import 'package:mobx_practices/demo/03_connectivity/connectivity_store.dart';
import 'package:mobx_practices/demo/04_login_form/form_widget.dart';

const _kDivider = Divider(thickness: 0.5, height: 0.5);

final _demos = <String, WidgetBuilder>{
  '01. Counter': (_) => CounterWidget(),
  '02. Clock': (_) => ClockWidget(),
  '03. Connectivity': (_) => ConnectivityWidget(ConnectivityStore()),
  '04. Form': (_) => FormWidget(),
};

class DemoDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 170,
                decoration: const FlutterLogoDecoration(),
              ),
              _kDivider,
              ...buildDemos(context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildDemos(BuildContext context) {
    List<Widget> demos = [];
    for (final entry in _demos.entries) {
      demos.add(ListTile(
        title: Text(entry.key),
        onTap: () {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: entry.value),
          );
        },
      ));
    }
    return demos;
  }
}
