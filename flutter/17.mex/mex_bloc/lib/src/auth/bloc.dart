import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mex_bloc/src/user/service.dart';

/// ======================================================
/// Auth Bloc
/// ======================================================
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepo userRepo;

  AuthBloc({this.userRepo}) : assert(userRepo != null) {
    log('DI: Initialise AuthBloc');
  }

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
  }
}

/// ======================================================
/// Auth Event
/// ======================================================

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

/// ======================================================
/// Auth State
/// ======================================================

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthUninitialized extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthLoading extends AuthState {}
