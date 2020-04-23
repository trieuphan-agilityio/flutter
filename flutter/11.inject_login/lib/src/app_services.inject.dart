import 'app_services.dart' as _i1;
import 'user.dart' as _i2;
import 'auth.dart' as _i3;
import 'login.dart' as _i4;
import 'dart:async' as _i5;

class AppServices$Injector implements _i1.AppServices {
  AppServices$Injector._(
      this._userServices, this._authServices, this._loginServices);

  final _i2.UserServices _userServices;

  final _i3.AuthServices _authServices;

  final _i4.LoginServices _loginServices;

  static _i5.Future<_i1.AppServices> create(_i2.UserServices userServices,
      _i3.AuthServices authServices, _i4.LoginServices loginServices) async {
    final injector =
        AppServices$Injector._(userServices, authServices, loginServices);

    return injector;
  }

  _i2.UserRepo _createUserRepo() => _userServices.userRepo();
  _i3.AuthBloc _createAuthBloc() => _authServices.authBloc(_createUserRepo());
  _i4.LoginBloc _createLoginBloc() =>
      _loginServices.loginBloc(_createUserRepo(), _createAuthBloc());
  @override
  _i2.UserRepo get userRepo => _createUserRepo();
  @override
  _i3.AuthBloc get authBLoc => _createAuthBloc();
  @override
  _i4.LoginBloc get loginBloc => _createLoginBloc();
}
