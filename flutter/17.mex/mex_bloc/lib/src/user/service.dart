import 'package:inject/inject.dart';
import 'package:meta/meta.dart';

/// Declares the public API to InheritWidget to expose.
abstract class UserServiceLocator {
  @provide
  UserRepo get userRepo;
}

@module
class UserService {
  @provide
  UserRepo userRepo() => UserRepo();
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
