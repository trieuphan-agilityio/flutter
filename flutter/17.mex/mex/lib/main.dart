import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mex/features/home.dart';
import 'package:mex_bloc/mex_bloc.dart';

import 'features/unregister_user.dart';

main() async {
  // run injection container
  final services = await createServices();
  runApp(App(services));
}

Future<MexServices> createServices() async {
  return await MexServices.create(
    UserService(),
    AuthService(),
    LoginService(),
  );
}

class App extends StatelessWidget {
  final MexServices services;

  const App(this.services, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => services.authBloc),
        BlocProvider<LoginBloc>(create: (_) => services.loginBloc),
      ],
      child: MaterialApp(
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: SharedAxisPageTransitionsBuilder(
                transitionType: SharedAxisTransitionType.scaled,
              )
            },
          ),
        ),
        routes: {
          '/': (_) => LoginWidget(),
          '/home': (_) => HomeWidget(),
        },
      ),
    );
  }
}
