import 'package:app/model.dart';

abstract class UserStoreReading {
  Future<List<User>> list();
  Future<User> getById(String id);
}

class UserStore implements UserStoreReading {
  @override
  Future<User> getById(String id) async {
    return _users.firstWhere((e) => e.id == id);
  }

  @override
  Future<List<User>> list() async {
    return [..._users];
  }

  static final List<User> _users = [
    User('kim', 'Kim', UserRole.captain),
    User('john', 'John', UserRole.member),
    User('jane', 'Jane', UserRole.member),
    User('julie', 'Julie', UserRole.member),
  ];
}
