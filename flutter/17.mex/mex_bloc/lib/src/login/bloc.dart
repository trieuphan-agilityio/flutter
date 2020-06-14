import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mex_bloc/src/auth/bloc.dart';
import 'package:mex_bloc/src/user/service.dart';

/// =======================================================
/// Login Bloc
/// =======================================================

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  static LoginBloc of(BuildContext context) {
    return BlocProvider.of<LoginBloc>(context);
  }

  final UserRepo userRepo;
  final AuthBloc authBloc;

  LoginBloc({
    @required this.userRepo,
    @required this.authBloc,
  })  : assert(userRepo != null),
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

/// =======================================================
/// Login State
/// =======================================================

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
}

/// =======================================================
/// Login Event
/// =======================================================

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
}
