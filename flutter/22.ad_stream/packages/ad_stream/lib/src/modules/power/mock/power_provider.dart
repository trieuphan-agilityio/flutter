import 'dart:async';

import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

@visibleForTesting
class AlwaysStrongPowerProvider implements PowerProvider {
  final StreamController<PowerState> _controller;

  AlwaysStrongPowerProvider()
      : _controller = BehaviorSubject.seeded(PowerState.strong);

  Stream<PowerState> get state$ => _controller.stream;
}
