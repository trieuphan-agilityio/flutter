import 'dart:async';

import 'package:rxdart/rxdart.dart';

enum PowerState { weak, strong }

abstract class PowerProvider {
  Stream<PowerState> get state$;
}

class PowerProviderImpl implements PowerProvider {
  final StreamController<PowerState> _state$Controller;

  PowerProviderImpl()
      : _state$Controller = BehaviorSubject.seeded(PowerState.weak);

  @override
  Stream<PowerState> get state$ => _state$Controller.stream;
}
