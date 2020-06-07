import 'package:inject/inject.dart';
import 'package:mex_bloc/src/auth/bloc.dart';
import 'package:mex_bloc/src/user/service.dart';

import 'bloc.dart';

/// Provides service locator for login feature.
LoginServiceLocator loginService;

abstract class LoginServiceLocator {
  @provide
  LoginBloc get loginBloc;
}

@module
class LoginService {
  @provide
  LoginBloc loginBloc(UserRepo userRepo, AuthBloc authBloc) =>
      LoginBloc(userRepo: userRepo, authBloc: authBloc);
}
