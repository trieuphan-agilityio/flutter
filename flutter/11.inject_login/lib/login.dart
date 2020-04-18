import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:inject/inject.dart';

import 'auth.dart';
import 'user.dart';

/// ===================================================================
/// Auth Module
/// ===================================================================

/// Provides service locator for user feature code.
LoginServiceLocator loginServices;

abstract class LoginServiceLocator {
  @provide
  LoginBloc get loginBloc;
}

@module
class LoginServices {
  @provide
  LoginBloc loginBloc(
    UserRepo userRepo,
    AuthBloc authBloc,
  ) =>
      new LoginBloc(userRepo: userRepo, authBloc: authBloc);
}

/// ===================================================================
/// Login Bloc
/// ===================================================================

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepo userRepo;
  final AuthBloc authBloc;

  LoginBloc({this.userRepo, this.authBloc})
      : assert(userRepo != null),
        assert(authBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      String token;
      try {
        token = await userRepo.authenticate(
          username: event.username,
          password: event.password,
        );
      } catch (error) {
        yield LoginFailure(error: error.toString());
        return;
      }

      authBloc.add(LoggedIn(token: token));
      yield LoginInitial();
    }
  }
}

/// ===================================================================
/// Login State
/// ===================================================================

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'LoginFailure{error: $error}';
  }
}

/// ===================================================================
/// Login Events
/// ===================================================================

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  const LoginButtonPressed({
    @required this.username,
    @required this.password,
  });

  @override
  List<Object> get props => [username, password];

  @override
  String toString() {
    return 'LoginButtonPressed{username: $username, password: $password}';
  }
}
