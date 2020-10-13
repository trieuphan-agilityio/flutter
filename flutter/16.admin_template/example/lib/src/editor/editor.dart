enum EditorRole { moderator, reviewer, composer }

class Editor {
  final String id;
  final String name;
  final String bio;
  final Iterable<EditorRole> roles;
  final bool isOnline;

  Editor({
    this.id,
    this.name,
    this.bio,
    this.roles,
    this.isOnline,
  });

  Editor copyWith({
    String id,
    String name,
    String bio,
    Iterable<EditorRole> roles,
    bool isOnline,
  }) {
    return Editor(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      roles: roles ?? this.roles,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
