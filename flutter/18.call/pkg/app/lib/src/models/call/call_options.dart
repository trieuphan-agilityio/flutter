class CallOptions {
  /// Recipient's identity.
  final String identity;

  /// Type of the call which is either voice call or video call.
  final CallType type;

  CallOptions({this.identity, this.type});
}

enum CallType { voice, video }
