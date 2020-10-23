import 'package:admin_template/admin_template.dart';
import 'package:animations/animations.dart';
import 'package:example/src/user/user_add_form.dart';
import 'package:example/src/web_page/web_page.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
              icon: const Icon(Icons.public),
              label: Text('Publish', style: theme.textTheme.button),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.group),
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
            child: _selectedIndex == 0 ? WebPageDemo() : _UserFormDemo(),
          ),
        ),
      ],
    );
  }
}

/// ===================================================================
/// User form demo
/// ===================================================================

class _UserFormDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserAddForm(
      initialModel: UserAddModel(
        username: 'john_doe',
        email: 'johndoe@example.com',
        phone: '561111111',
        password: '',
        passwordConfirmation: '',
        acceptActivityEmail: false,
        groups: const [UserRole.editor],
      ),
      onSaved: (newValue) => _notifySaveSuccess(
        context,
        title: newValue.username,
        content: newValue.toString(),
      ),
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
