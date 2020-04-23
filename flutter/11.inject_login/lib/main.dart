import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/app_services.dart';
import 'src/auth.dart';
import 'src/login.dart';
import 'src/user.dart';

Future main() async {
  final services = await AppServices.create(
    new UserServices(),
    new AuthServices(),
    new LoginServices(),
  );
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(RepositoryProvider.value(
    value: services,
    child: MyApp(),
  ));
}

/// ===================================================================
/// Bloc Delegate
/// ===================================================================

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

/// ===================================================================
/// Main App
/// ===================================================================

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final services = RepositoryProvider.of<AppServices>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
          bloc: services.authBLoc,
          builder: (context, state) {
            if (state is AuthUninitialized) {
              return SplashScreen();
            }
            if (state is AuthAuthenticated) {
              return HomeScreen();
            }
            if (state is AuthUnauthenticated) {
              return LoginScreen();
            }
            if (state is AuthLoading) {
              return LoadingIndicator();
            }
            return null;
          }),
    );
  }
}

/// ===================================================================
/// Splash Screen
/// ===================================================================

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final services = RepositoryProvider.of<AppServices>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        child: Center(
            child: RaisedButton(
          onPressed: () {
            services.authBLoc.add(LoggedOut());
          },
          child: Text('logout'),
        )),
      ),
    );
  }
}

/// ===================================================================
/// LoginScreen
/// ===================================================================

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final services = RepositoryProvider.of<AppServices>(context);
    _onLoginButtonPressed() {
      services.loginBloc.add(LoginButtonPressed(
        username: _usernameController.text,
        password: _passwordController.text,
      ));
    }

    return BlocListener<LoginBloc, LoginState>(
      bloc: services.loginBloc,
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
          bloc: services.loginBloc,
          builder: (context, state) {
            return Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'username'),
                    controller: _usernameController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'password'),
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  RaisedButton(
                    onPressed:
                        state is! LoginLoading ? _onLoginButtonPressed : null,
                    child: Text('Login'),
                  ),
                  Container(
                    child: state is LoginLoading
                        ? CircularProgressIndicator()
                        : null,
                  ),
                ],
              ),
            );
          }),
    );
  }
}

/// ===================================================================
/// Loading Indicator
/// ===================================================================

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
