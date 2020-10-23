import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _kMaxFormWidth = 800.0;

class AgForm extends StatelessWidget {
  final Iterable<Widget> fields;

  final WillPopCallback onWillPop;

  final VoidCallback onChanged;

  const AgForm({Key key, this.fields, this.onWillPop, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.loose(Size(_kMaxFormWidth, double.infinity)),
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          // Pressing enter on the field will now move to the next field.
          LogicalKeySet(LogicalKeyboardKey.enter): const NextFocusIntent(),
        },
        child: Form(
          onWillPop: onWillPop,
          onChanged: onChanged,
          child: Builder(builder: (BuildContext context) {
            return SingleChildScrollView(
              child: FocusTraversalGroup(
                child: Column(
                  children: <Widget>[
                    ..._joinWidgets(fields, const SizedBox(height: 20)),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

Iterable<Widget> _joinWidgets(
  Iterable<Widget> widgets,
  Widget separator,
) sync* {
  if (widgets.length <= 1) yield* widgets;
  for (final w in widgets) {
    yield w;
    // no separator after the latest widget.
    if (w != widgets.last) yield separator;
  }
}
