/// Ticker expose a tick function which takes the given number of ticks (seconds),
/// and returns a stream which emits the remaining seconds every second.
class Ticker {
  Stream<int> tick({int ticks}) {
    return Stream.periodic(Duration(seconds: 1), (x) {
      print(x);
      return ticks - x - 1;
    }).take(ticks);
  }
}
