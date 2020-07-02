import 'package:meta/meta.dart';

class CallOptions {
  final String myIdentity;
  final String recipientIdentity;
  final bool isVideoCall;

  bool get isVoiceCall => !isVideoCall;

  CallOptions({
    @required this.myIdentity,
    @required this.recipientIdentity,
    this.isVideoCall = false,
  });
}
