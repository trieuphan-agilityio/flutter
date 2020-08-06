/// A zero-millisecond timer should wait until after all microtasks.
Future flushMicrotasks() => Future.delayed(Duration.zero);
