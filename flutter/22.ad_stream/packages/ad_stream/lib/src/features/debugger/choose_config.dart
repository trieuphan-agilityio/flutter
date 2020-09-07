import 'package:ad_stream/base.dart';
import 'package:ad_stream/di.dart';
import 'package:flutter/material.dart';

class ChooseConfig extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adProvider = DI.of(context).configProvider;
    return Scaffold(
      appBar: AppBar(title: Text('Choose Config')),
      body: Column(children: [
        ListTile(
          key: const Key('test_config'),
          title: Text('Test Config'),
          subtitle: Text('Config that is usually used in testing'),
          onTap: () {
            adProvider.config = adProvider.config.copyWith(
              defaultAdRepositoryRefreshInterval: 3,
              defaultAdSchedulerRefreshInterval: 3,
              defaultAdPresenterHealthCheckInterval: 3,
            );
            Navigator.of(context).pop();
          },
        )
      ]),
    );
  }
}
