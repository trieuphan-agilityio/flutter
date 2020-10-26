import 'package:admin_template/src/form/form_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _kMaxFormWidth = 800.0;

class AgForm extends StatelessWidget {
  final Iterable<Widget> fields;

  final AgFormFooter footer;

  final WillPopCallback onWillPop;

  final VoidCallback onChanged;

  const AgForm(
      {Key key,
      @required this.fields,
      @required this.footer,
      this.onWillPop,
      this.onChanged})
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
                    const SizedBox(height: 20),
                    footer,
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

/// Concatenates the widgets, with the [separator] interleaved widget between
/// the widgets.
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
