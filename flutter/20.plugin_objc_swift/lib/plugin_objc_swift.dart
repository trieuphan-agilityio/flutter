import 'dart:async';

import 'package:plugin_objc_swift/messages.dart';

class PluginObjcSwift {
  static HelloApi api = HelloApi();

  static Future<String> get platformVersion async {
    final msg = HelloMessage();
    msg.name = "John";
    final String greeting = await api.helloAndReply(msg).then((v) => v.reply);
    return greeting;
  }
}
