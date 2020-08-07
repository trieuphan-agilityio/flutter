import 'dart:async';

import 'package:rxdart/rxdart.dart';

enum PowerStatus { WEAK, STRONG }

abstract class PowerProvider {
  Stream<PowerStatus> get status$;
}

class PowerProviderImpl implements PowerProvider {
  @override
  // TODO: implement status
  Stream<PowerStatus> get status$ => throw UnimplementedError();
}

class AlwaysStrongPowerProvider implements PowerProvider {
  final StreamController<PowerStatus> status$Controller;

  AlwaysStrongPowerProvider()
      : status$Controller = BehaviorSubject.seeded(PowerStatus.STRONG);

  Stream<PowerStatus> get status$ => status$Controller.stream;
}
