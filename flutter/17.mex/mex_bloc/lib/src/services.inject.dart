import 'services.dart' as _i1;
import 'user/service.dart' as _i2;
import 'auth/service.dart' as _i3;
import 'auth/bloc.dart' as _i4;
import 'login/service.dart' as _i5;
import 'login/bloc.dart' as _i6;
import 'dart:async' as _i7;

class MexServices$Injector implements _i1.MexServices {
  MexServices$Injector._(
      this._userService, this._authService, this._loginService);

  final _i2.UserService _userService;

  final _i3.AuthService _authService;

  _i4.AuthBloc _singletonAuthBloc;

  final _i5.LoginService _loginService;

  _i6.LoginBloc _singletonLoginBloc;

  static _i7.Future<_i1.MexServices> create(_i2.UserService userService,
      _i3.AuthService authService, _i5.LoginService loginService) async {
    final injector =
        MexServices$Injector._(userService, authService, loginService);

    return injector;
  }

  _i2.UserRepo _createUserRepo() => _userService.userRepo();
  _i4.AuthBloc _createAuthBloc() =>
      _singletonAuthBloc ??= _authService.authBloc(_createUserRepo());
  _i6.LoginBloc _createLoginBloc() => _singletonLoginBloc ??=
      _loginService.loginBloc(_createUserRepo(), _createAuthBloc());
  @override
  _i2.UserRepo get userRepo => _createUserRepo();
  @override
  _i4.AuthBloc get authBloc => _createAuthBloc();
  @override
  _i6.LoginBloc get loginBloc => _createLoginBloc();
}
