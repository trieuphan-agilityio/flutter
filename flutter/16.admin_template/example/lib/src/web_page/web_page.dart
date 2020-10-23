import 'package:admin_template/admin_template.dart';
import 'package:flutter/material.dart';

class WebPageDemo extends StatefulWidget {
  final WillPopCallback onWillPop;
  final VoidCallback onChanged;
  final ValueChanged onSaved;

  const WebPageDemo({Key key, this.onWillPop, this.onChanged, this.onSaved})
      : super(key: key);

  @override
  _WebPageDemoState createState() => _WebPageDemoState();
}

class _WebPageDemoState extends State<WebPageDemo> {
  @override
  Widget build(BuildContext context) {
    return AgScaffold(
      header: AgHeader(
        icon: const Icon(Icons.group),
        title: const Text('New User'),
      ),
      body: AgForm(
        fields: [],
      ),
    );
  }
}
