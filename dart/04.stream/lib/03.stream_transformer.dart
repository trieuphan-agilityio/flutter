import 'dart:async';

void main() {
  final duplicator = const StreamTransformer<int, int>(_onListen);

  Stream<int> intStream = Stream.periodic(Duration(milliseconds: 250), (i) {
    return i;
  });

  intStream.transform(duplicator).listen((event) {
    print(event);
  });
}

StreamSubscription<int> _onListen(Stream<int> input, bool cancelOnError) {
  StreamSubscription<int> subscription;

  // Create controller that forwards pause, resume and cancel events.
  var controller = new StreamController<int>(
    sync: true, // "sync" is correct here, since events are forwarded.
    onPause: () {
      subscription.pause();
    },
    onResume: () {
      subscription.resume();
    },
    onCancel: () => subscription.cancel(),
  );

  // Listen to the provided stream using `cancelOnError`.
  subscription = input.listen((data) {
    // Duplicate the data.
    controller.add(data);
    controller.add(data);
  },
      onError: controller.addError,
      onDone: controller.close,
      cancelOnError: cancelOnError);

  // Return a new [StreamSubscription] by listening to the controller's stream.
  return controller.stream.listen(null);
}
