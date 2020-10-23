import 'package:flutter/material.dart';

class AgHeader extends StatelessWidget {
  final Widget icon;
  final Widget title;

  const AgHeader({Key key, this.icon, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: title,
      ),
    );
  }
}
