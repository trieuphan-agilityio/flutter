import 'package:ad_stream/src/features/debugger/dashboard.dart';
import 'package:flutter/material.dart';

const _kDivider = const Divider(height: 0.5, thickness: 0.5);

class DebugDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: const Key('debug_drawer'),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(children: [
            Container(
              height: 180,
              decoration: const FlutterLogoDecoration(),
            ),
            _kDivider,
            ...WidgetUtils.join(buildOptions(context), _kDivider),
          ]),
        ),
      ),
    );
  }

  List<Widget> buildOptions(BuildContext context) {
    return [
      ListTile(
        key: const Key('open_debug_dashboard'),
        title: Text('Open Debug Dashboard'),
        onTap: () {
          // close drawer
          Navigator.pop(context);

          // open debug dashboard
          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) {
                return DebugDashboard();
              },
            ),
          );
        },
      ),
    ];
  }
}

class WidgetUtils {
  /// join function for the list of Widgets
  static List<Widget> join(List<Widget> widgets, Widget separator) {
    Iterator<Widget> iterator = widgets.iterator;
    if (!iterator.moveNext()) return [];

    if (separator == null) return widgets;

    List<Widget> newList = [];
    newList.add(iterator.current);

    while (iterator.moveNext()) {
      newList.add(separator);
      newList.add(iterator.current);
    }

    return newList;
  }
}
