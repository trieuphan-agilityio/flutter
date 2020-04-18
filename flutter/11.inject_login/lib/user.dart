import 'package:flutter/foundation.dart';
import 'package:inject/inject.dart';

/// Provides service locator for user feature code.
UserServiceLocator userServices;

/// Declares dependencies used by the login feature.
abstract class UserServiceLocator {
  @provide
  UserRepo get userRepo;
}

/// Declares dependencies needed by the food car.
@module
class UserServices {
  @provide
  UserRepo userRepo() => new UserRepo();
}

class UserRepo {
  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    return 'token';
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    /// ready from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return false;
  }
}
