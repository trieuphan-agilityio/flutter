import 'package:inject/inject.dart';
import 'package:mex_bloc/src/auth/bloc.dart';
import 'package:mex_bloc/src/user/service.dart';

AuthServiceLocator authService;

abstract class AuthServiceLocator {
  @provide
  AuthBloc get authBloc;
}

@module
class AuthService {
  @provide
  AuthBloc authBloc(UserRepo userRepo) => AuthBloc(userRepo: userRepo);
}
