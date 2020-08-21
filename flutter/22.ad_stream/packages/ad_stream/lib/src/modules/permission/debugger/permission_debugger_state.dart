class PermissionDebuggerState {
  final int value;
  final String name;

  const PermissionDebuggerState._(this.value, this.name);

  static const PermissionDebuggerState off =
      PermissionDebuggerState._(0, 'Off');

  static const PermissionDebuggerState allow =
      PermissionDebuggerState._(1, 'Always allowed');

  static const PermissionDebuggerState deny =
      PermissionDebuggerState._(2, 'Always denied');

  static const List<PermissionDebuggerState> values = [
    PermissionDebuggerState.off,
    PermissionDebuggerState.allow,
    PermissionDebuggerState.deny,
  ];

  /// Get state by its value, return null if not found.
  static PermissionDebuggerState stateByValue(int value) {
    try {
      return [
        PermissionDebuggerState.off,
        PermissionDebuggerState.allow,
        PermissionDebuggerState.deny,
      ][value];
    } catch (_) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PermissionDebuggerState &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
