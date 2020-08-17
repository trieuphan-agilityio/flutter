import 'dart:async';

import 'package:rxdart/rxdart.dart';

enum PowerStatus { weak, strong }

abstract class PowerProvider {
  Stream<PowerStatus> get status$;
}

class PowerProviderImpl implements PowerProvider {
  final StreamController<PowerStatus> _status$Controller;

  PowerProviderImpl()
      : _status$Controller = BehaviorSubject.seeded(PowerStatus.weak);

  @override
  Stream<PowerStatus> get status$ => _status$Controller.stream;
}
