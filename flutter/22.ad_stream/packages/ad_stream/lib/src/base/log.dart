abstract class Log {
  static debug(Object object) {
    String line = object.toString();
    print("[D] $line");
  }

  static info(Object object) {
    String line = object.toString();
    print("[I] $line");
  }

  static warn(Object object) {
    String line = object.toString();
    print("[W] $line");
  }
}
