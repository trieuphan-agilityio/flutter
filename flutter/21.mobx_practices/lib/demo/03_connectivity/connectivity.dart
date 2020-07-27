import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_practices/demo/03_connectivity/connectivity_store.dart';
import 'package:mobx_practices/demo/drawer.dart';

class ConnectivityWidget extends StatefulWidget {
  const ConnectivityWidget(this.store, {Key key}) : super(key: key);

  final ConnectivityStore store;

  @override
  _ConnectivityWidgetState createState() => _ConnectivityWidgetState();
}

class _ConnectivityWidgetState extends State<ConnectivityWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();

    // a delay is used to avoid showing the snackbar too much when the connection
    // drops in and out repeatedly.
    _disposer = reaction(
        (_) => widget.store.connectivityStream.value,
        (result) => _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(result == ConnectivityResult.none
                ? 'You\'re offline'
                : 'You\'re online'))),
        delay: 4000);
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Connectivity')),
      drawer: DemoDrawer(),
      body: Container(
        padding: EdgeInsets.all(16),
        child:
            Text('Turn your connection on/off for approximately 4 seconds to '
                'see the app respond to changes in your connection status.'),
      ),
    );
  }
}
