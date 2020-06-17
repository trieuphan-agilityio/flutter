import 'package:admin_template/admin_template.dart';
import 'package:animations/animations.dart';
import 'package:built_collection/built_collection.dart';
import 'package:example/src/user/user.dart';
import 'package:example/src/web_page/web_page.dart';
import 'package:example/src/web_page/web_page_form.dart';
import 'package:flutter/material.dart';

import 'user.dart';

void main() {
  runApp(MaterialApp(
    themeMode: ThemeMode.light,
    theme: shrineTheme,
    darkTheme: rallyTheme,
    home: Scaffold(body: _Demo()),
  ));
}

class _Demo extends StatefulWidget {
  @override
  __DemoState createState() => __DemoState();
}

class __DemoState extends State<_Demo> {
  int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: <Widget>[
        NavigationRail(
          selectedIndex: _selectedIndex,
          labelType: NavigationRailLabelType.selected,
          destinations: <NavigationRailDestination>[
            NavigationRailDestination(
              icon: Icon(Icons.public),
              label: Text('Publish', style: theme.textTheme.button),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.group),
              label: Text('Editor', style: theme.textTheme.button),
            ),
          ],
          onDestinationSelected: (int newIndex) {
            setState(() {
              _selectedIndex = newIndex;
            });
          },
        ),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(
          child: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return FadeThroughTransition(
                child: child,
                animation: animation,
                secondaryAnimation: secondaryAnimation,
              );
            },
            child: _selectedIndex == 0 ? _WebPageFormDemo() : _UserFormDemo(),
          ),
        ),
      ],
    );
  }
}

/// ===================================================================
/// WebPage form demo
/// ===================================================================

class _WebPageFormDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = WebPage((b) => b
      ..title = 'Flutter is awesome!'
      ..slug = 'flutter-is-awesome'
      ..live = true);
    return WebPageForm(model);
  }
}

/// ===================================================================
/// User form demo
/// ===================================================================

class _UserFormDemo extends StatefulWidget {
  const _UserFormDemo({Key key}) : super(key: key);

  @override
  _UserFormDemoState createState() => _UserFormDemoState();
}

class _UserFormDemoState extends State<_UserFormDemo> {
  User user;

  @override
  void initState() {
    super.initState();
    user = User((b) => b
      ..username = 'johndoe'
      ..email = 'johndoe@example.com'
      ..phone = '561111111'
      ..password = ''
      ..passwordConfirmation = ''
      ..acceptPromotionalEmail = false
      ..groups = ListBuilder());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          UserForm.edit(user).builder(context, onSaved: (User newValue) {
            setState(() {
              user = newValue;
            });
          }),
          Text(user.toString()),
        ],
      ),
    );
  }
}
