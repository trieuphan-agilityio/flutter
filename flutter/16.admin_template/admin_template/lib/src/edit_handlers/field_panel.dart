import 'package:flutter/material.dart';

import 'edit_handler.dart';

class FieldPanel extends EditHandler {
  final String fieldName;

  final Widget widget;

  final String helpText = '';

  final String error = '';

  FieldPanel({
    @required this.fieldName,
    this.widget,
  });

  @override
  Map<String, Widget> widgetOverrides() {
    // check if a specific widget has been defined for this field
    if (widget != null) return {fieldName: widget};
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Text('This is a label'),
      Expanded(
        child: Column(children: [
          widget,
          if (helpText != '') Text(helpText),
          if (error != '') Text(error),
        ]),
      ),
    ]);
  }
}
