import 'dart:async';

import 'package:inject/inject.dart';

import 'auth.dart';
import 'login.dart';
import 'user.dart';
import 'app_services.inject.dart' as g;

/// The top level injector that stitches together multiple app features into
/// a complete app.
@Injector(const [UserServices, AuthServices, LoginServices])
abstract class AppServices
    implements UserServiceLocator, AuthServiceLocator, LoginServiceLocator {
  static Future<AppServices> create(
    UserServices userModule,
    AuthServices authModule,
    LoginServices loginModule,
  ) async {
    var services = await g.AppServices$Injector.create(
      userModule,
      authModule,
      loginModule,
    );

    userServices = services;
    authServices = services;
    return services;
  }
}
