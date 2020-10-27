import 'package:cookbook/test/integration_test.dart';
import 'package:flutter/material.dart';

import 'theme/demo_button_style.dart';

main() {
  runApp(MaterialApp(home: App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cookbook')),
      body: SingleChildScrollView(
        child: Column(
          children: ListTile.divideTiles(
            context: context,
            tiles: _routes.entries
                .map((entry) => ListTile(
                      key: ValueKey(key),
                      title: Text(entry.key),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => entry.value(),
                        ));
                      },
                    ))
                .toList(),
          ).toList(),
        ),
      ),
    );
  }

  final Map<String, Widget Function()> _routes = {
    'Integration Test': () => IntegrationTest(title: 'Integration Test'),
    'Button Style': () => DemoButtonStyle(),
  };
}
