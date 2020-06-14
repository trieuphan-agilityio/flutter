import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mex/features/home.dart';
import 'package:mex_bloc/mex_bloc.dart';

import 'features/unregister_user.dart';

void main() async {
  // run injection container
  final mexServices = await MexServices.create(
    UserService(),
    AuthService(),
    LoginService(),
  );

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>(create: (_) => mexServices.authBloc),
      BlocProvider<LoginBloc>(create: (_) => mexServices.loginBloc),
    ],
    child: MaterialApp(
      routes: {
        '/': (_) => LoginWidget(),
        '/home': (_) => HomeWidget(),
      },
    ),
  ));
}
