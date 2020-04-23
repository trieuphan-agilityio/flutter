import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:inject/inject.dart';

import 'user.dart';

/// ===================================================================
/// Auth Module
/// ===================================================================

/// Provides service locator for user feature code.
AuthServiceLocator authServices;

abstract class AuthServiceLocator {
  @provide
  AuthBloc get authBLoc;
}

@module
class AuthServices {
  @provide
  AuthBloc authBloc(UserRepo repo) => new AuthBloc(userRepo: repo);
}

/// ===================================================================
/// Auth Bloc
/// ===================================================================

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepo userRepo;

  AuthBloc({this.userRepo}) : assert(userRepo != null);

  @override
  AuthState get initialState => AuthUninitialized();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStarted) {
      final bool hasToken = await userRepo.hasToken();

      if (hasToken) {
        yield AuthAuthenticated();
      } else {
        yield AuthUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthLoading();
      await userRepo.persistToken(event.token);
      yield AuthAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthLoading();
      await userRepo.deleteToken();
      yield AuthUnauthenticated();
    }
  }
}

// event

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String token;

  const LoggedIn({@required this.token});

  @override
  List<Object> get props => [token];

  @override
  String toString() {
    return 'LoggedIn{token: $token}';
  }
}

class LoggedOut extends AuthEvent {}

// state

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthUninitialized extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthLoading extends AuthState {}
