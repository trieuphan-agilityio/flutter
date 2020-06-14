import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inject/inject.dart';
import 'package:mex_bloc/src/auth/service.dart';
import 'package:mex_bloc/src/login/service.dart';
import 'package:mex_bloc/src/user/service.dart';

import 'services.inject.dart' as g;

@Injector([
  UserService,
  AuthService,
  LoginService,
])
abstract class MexServices
    implements UserServiceLocator, AuthServiceLocator, LoginServiceLocator {
  static Future<MexServices> create(
    UserService userModule,
    AuthService authModule,
    LoginService loginModule,
  ) async {
    var services = await g.MexServices$Injector.create(
      userModule,
      authModule,
      loginModule,
    );

    return services;
  }
}
