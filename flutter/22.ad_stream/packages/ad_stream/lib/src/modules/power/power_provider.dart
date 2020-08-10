import 'dart:async';

enum PowerStatus { WEAK, STRONG }

abstract class PowerProvider {
  Stream<PowerStatus> get status$;
}

class PowerProviderImpl implements PowerProvider {
  @override
  Stream<PowerStatus> get status$ => Stream.empty();
}
