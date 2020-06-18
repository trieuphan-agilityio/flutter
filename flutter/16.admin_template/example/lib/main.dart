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
    debugShowCheckedModeBanner: false,
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
    final newWebPage = WebPage((b) => b
      ..title = 'Flutter is awesome!'
      ..slug = 'flutter-is-awesome');

    return WebPageCreatingForm(
      initialModel: newWebPage,
      onSaved: (WebPage newValue) {
        _notifySaveSuccess(
          context,
          title: newValue.title,
          content: newValue.toString(),
        );
      },
    );
  }
}

/// ===================================================================
/// User form demo
/// ===================================================================

class _UserFormDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final initialModel = User((b) => b
      ..username = 'john_doe'
      ..email = 'johndoe@example.com'
      ..phone = '561111111'
      ..password = ''
      ..passwordConfirmation = ''
      ..acceptPromotionalEmail = false
      ..groups = ListBuilder());

    return UserForm.edit(initialModel).builder(
      context,
      onSaved: (User newValue) {
        _notifySaveSuccess(
          context,
          title: newValue.username,
          content: newValue.toString(),
        );
      },
    );
  }
}

_notifySaveSuccess(
  BuildContext context, {
  @required String title,
  @required String content,
}) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text('"$title" is saved successfully'),
    action: SnackBarAction(
      label: 'Show me',
      onPressed: () {
        showDialog(
          context: context,
          child: SimpleDialog(
            title: Text(title),
            children: [Text(content)],
            contentPadding: const EdgeInsets.all(40),
          ),
        );
      },
    ),
  ));
}
