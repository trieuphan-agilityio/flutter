import 'package:flutter/material.dart';

/// A decorator that displays the input control [child] next to the [labelText].
class FieldPanel extends StatelessWidget {
  final Widget child;
  final String labelText;

  const FieldPanel({
    Key key,
    @required this.child,
    this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (labelText == null) return child;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Padding(
            padding: EdgeInsets.only(top: 18),
            child: Text(
              labelText,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(child: child),
      ],
    );
  }
}
