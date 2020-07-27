import 'package:stream_transform/stream_transform.dart';

final Stream<int> _values =
    Stream.fromIterable([1, 2, 7, 3, 1]).asBroadcastStream();

main() {
  demoAsyncMap();
  // output: 10, 20, 70, 30, 10

  demoAsyncMapSample();
  // output: 10, 10

  demoAsyncMapBuffer();
  // output: 10, 130

  demoConcurrentAsyncMap();
  // output: 10, 10, 20, 30, 70
}

demoAsyncMap() {
  _values.asyncMap((num) => _multiplyNumber(num)).listen((event) {
    print('asyncMap: $event');
  });
}

demoAsyncMapSample() {
  _values.asyncMapSample((num) => _multiplyNumber(num)).listen((event) {
    print('asyncMapSample: $event');
  });
}

demoAsyncMapBuffer() {
  int sum(int a, int b) => a + b;

  _values
      .asyncMapBuffer((List<int> nums) => _multiplyNumber(nums.reduce(sum)))
      .listen((event) {
    print('asyncMapBuffer: $event');
  });
}

demoConcurrentAsyncMap() {
  _values.concurrentAsyncMap((num) => _multiplyNumber(num)).listen((event) {
    print('concurrentAsyncMap: $event');
  });
}

Future<int> _multiplyNumber(int number) {
  // big number longer delayed
  return Future.delayed(
    Duration(seconds: number),
    () => Future.value(number * 10),
  );
}
