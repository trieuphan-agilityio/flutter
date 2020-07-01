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
  opts.dartOut = '../pigeon_hello_platform_interface/lib/messages.dart';
  opts.objcHeaderOut = 'ios/Classes/messages.h';
  opts.objcSourceOut = 'ios/Classes/messages.m';
  opts.objcOptions.prefix = 'FLT';
  opts.javaOut =
      'android/src/main/java/com/example/pigeon_hello_plugin/Messages.java';
  opts.javaOptions.package = 'com.example.pigeon_hello_plugin';
}
