import 'package:cookbook/test/integration_test.dart';
import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(home: App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...ListTile.divideTiles(context: context, tiles: [
              ListTile(
                key: Key('intergration_test'),
                title: Text('Integration Test'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        IntegrationTest(title: 'Integration Test'),
                  ));
                },
              ),
            ])
          ],
        ),
      ),
    );
  }
}
