import 'dart:async';

import 'package:ad_stream/src/creative/targeting_value.dart';

abstract class AdTargeting {
  Stream<TargetingValues> get stream;
}

class AdTargetingImpl extends AdTargeting {
  AdTargetingImpl() : this._streamController = StreamController();

  final StreamController<TargetingValues> _streamController;

  @override
  Stream<TargetingValues> get stream =>
      _streamController.stream.asBroadcastStream();
}
