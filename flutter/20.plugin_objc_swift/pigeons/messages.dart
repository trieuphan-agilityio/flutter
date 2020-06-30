import 'package:pigeon/pigeon_lib.dart';

class HelloMessage {
  String name;
}

class ReplyMessage {
  String reply;
}

@HostApi()
abstract class HelloApi {
  void initialize();
  void hello(HelloMessage msg);
  ReplyMessage helloAndReply(HelloMessage msg);
}

void configurePigeon(PigeonOptions opts) {
  opts.dartOut = 'lib/messages.dart';
  opts.objcHeaderOut = 'ios/Classes/messages.h';
  opts.objcSourceOut = 'ios/Classes/messages.m';
  opts.objcOptions.prefix = 'FLT';
  opts.javaOut =
      'android/src/main/java/com/example/plugin_objc_swift/Messages.java';
  opts.javaOptions.package = 'com.example.plugin_objc_swift';
}
