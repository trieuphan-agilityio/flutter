enum UserRole { captain, member, admin }

class User {
  final String id;
  final String name;
  final UserRole role;

  User(this.id, this.name, this.role);
}
