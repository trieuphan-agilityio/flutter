import 'package:app/app_services.dart';
import 'package:app/core.dart';
import 'package:app/src/call/call_bloc.dart';
import 'package:app/src/member/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/auth/auth.dart';
import 'src/home/home.dart';

void main() {
  /// Some services such as SharedPreferences need access to binary messenger
  /// before app run. Therefore we need to initialise Flutter Binding from early.
  WidgetsFlutterBinding.ensureInitialized();

  final appServices = AppServices.create(
    VideoCallService(),
    AuthService(),
    SettingsService(),
    UserService(),
  );

  runApp(App(appServices));
}

class App extends StatelessWidget {
  const App(this.appServices, {Key key}) : super(key: key);

  final Future<AppServices> appServices;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: appServices,
      builder: (context, snapshot) {
        // Show the splash screen
        if (!snapshot.hasData) return Splash();

        // Show main content
        return Provider<AppServices>.value(
          value: snapshot.data,
          child: MultiBlocProvider(
              providers: <BlocProvider>[
                BlocProvider<CallBloc>(create: (_) => CallBloc()),
              ],
              child: MaterialApp(
                routes: {
                  '/': (_) => Auth(),
                  '/home': (_) => Home(),
                  '/member': (_) => Member(),
                },
              )),
        );
      },
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 200,
          alignment: Alignment.center,
          decoration: const FlutterLogoDecoration(),
        )
      ],
    );
  }
}
