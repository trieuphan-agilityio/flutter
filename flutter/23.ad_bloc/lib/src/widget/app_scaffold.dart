import 'package:ad_bloc/base.dart';

import 'debug_button.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;

  const AppScaffold({Key key, @required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: body),
      floatingActionButton: const DebugButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
