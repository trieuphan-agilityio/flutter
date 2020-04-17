import 'package:bloc_login/bloc/auth_bloc.dart';
import 'package:bloc_login/bloc/auth_state.dart';
import 'package:bloc_login/bloc/login.dart';
import 'package:bloc_login/repo/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth_event.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepo = UserRepo();
  runApp(BlocProvider<AuthBloc>(
    create: (context) {
      return AuthBloc(userRepo: userRepo)..add(AppStarted());
    },
    child: MyApp(userRepo: userRepo),
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
  final UserRepo userRepo;

  MyApp({Key key, this.userRepo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        if (state is AuthUninitialized) {
          return SplashScreen();
        }
        if (state is AuthAuthenticated) {
          return HomeScreen();
        }
        if (state is AuthUnauthenticated) {
          return LoginScreen(userRepo: userRepo);
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        child: Center(
            child: RaisedButton(
          onPressed: () {
            BlocProvider.of<AuthBloc>(context).add(LoggedOut());
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
  final UserRepo userRepo;

  LoginScreen({Key key, this.userRepo})
      : assert(userRepo != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: BlocProvider(
          create: (context) {
            return LoginBloc(
              authBloc: BlocProvider.of<AuthBloc>(context),
              userRepo: userRepo,
            );
          },
          child: LoginForm(),
        ));
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
    _onLoginButtonPressed() {
      BlocProvider.of<LoginBloc>(context).add(LoginButtonPressed(
        username: _usernameController.text,
        password: _passwordController.text,
      ));
    }

    return BlocListener<LoginBloc, LoginState>(
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
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
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
                child:
                    state is LoginLoading ? CircularProgressIndicator() : null,
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
    return Center(child: CircularProgressIndicator());
  }
}
