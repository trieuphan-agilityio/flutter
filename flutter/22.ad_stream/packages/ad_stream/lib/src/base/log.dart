import 'dart:developer';

abstract class Log {
  static debug(Object object) {
    String line = object.toString();
    log("[D] $line");
  }

  static info(Object object) {
    String line = object.toString();
    log("[I] $line");
  }

  static warn(Object object) {
    String line = object.toString();
    log("[W] $line");
  }
}
