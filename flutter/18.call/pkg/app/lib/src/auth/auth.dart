import 'package:app/src/app_services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Auth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login As', style: textTheme.headline5),
            const SizedBox(height: 16),
            ...buildIdentities(context),
          ],
        ),
      ),
    );
  }

  List<Widget> buildIdentities(BuildContext context) {
    return [
      RaisedButton(
        onPressed: () => _useIdentityAndRouteToHome(context, 'kim'),
        child: Text('Kim (Captain)'),
      ),
      const SizedBox(height: 8),
      RaisedButton(
        onPressed: () => _useIdentityAndRouteToHome(context, 'john'),
        child: Text('John'),
      ),
      const SizedBox(height: 8),
      RaisedButton(
        onPressed: () => _useIdentityAndRouteToHome(context, 'julie'),
        child: Text('Julie'),
      ),
    ];
  }

  _useIdentityAndRouteToHome(BuildContext context, String identity) {
    final appSettingsStore = AppServices.of(context).appSettingsStore;
    appSettingsStore.myIdentity = identity;
    Navigator.pushReplacementNamed(context, '/home');
  }
}
