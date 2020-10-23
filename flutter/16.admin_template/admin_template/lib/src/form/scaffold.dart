import 'package:flutter/material.dart';

class AgScaffold extends StatelessWidget {
  final Widget header;
  final Widget body;

  const AgScaffold({Key key, this.header, this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        Padding(padding: const EdgeInsets.all(16), child: body),
      ],
    );
  }
}
