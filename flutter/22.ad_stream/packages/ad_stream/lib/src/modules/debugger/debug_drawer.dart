import 'package:ad_stream/src/modules/debugger/debugger.dart';
import 'package:flutter/material.dart';

const _kDivider = const Divider(height: 0.5, thickness: 0.5);

class DebugDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
        title: Text('Open Debugger'),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) {
                return Debugger();
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
