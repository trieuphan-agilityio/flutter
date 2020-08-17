import 'dart:async';

import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

@visibleForTesting
class AlwaysStrongPowerProvider implements PowerProvider {
  final StreamController<PowerStatus> _controller;

  AlwaysStrongPowerProvider()
      : _controller = BehaviorSubject.seeded(PowerStatus.strong);

  Stream<PowerStatus> get status$ => _controller.stream;
}
