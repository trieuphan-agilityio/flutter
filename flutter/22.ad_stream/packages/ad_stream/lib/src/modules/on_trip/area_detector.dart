import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:rxdart/rxdart.dart';

abstract class AreaDetector implements Service {
  Stream<List<Area>> get areas$;
}

class AreaDetectorImpl with ServiceMixin implements AreaDetector {
  final StreamController<List<Area>> _controller;
  final Stream<LatLng> _latLng$;
  final Config _config;

  AreaDetectorImpl(this._latLng$, this._config)
      : _controller = BehaviorSubject<List<Area>>();

  Stream<List<Area>> get areas$ => _controller.stream;

  Future<List<Area>> _detectAreas(LatLng latLng) async {
    // FIXME
    return [Area('Da Nang')];
  }

  @override
  Future<void> start() {
    super.start();

    final subscription = this
        ._latLng$
        .sampleTime(Duration(seconds: _config.areaRefreshInterval))
        .listen((latLng) async {
      final areas = await _detectAreas(latLng);
      _controller.add(areas);

      Log.debug('AreaDetector detected'
          ' ${areas.length} ${areas.length > 1 ? "areas" : "area"}.');
    });

    _disposer.autoDispose(subscription);

    Log.info('AreaDetector started.');
    return null;
  }

  @override
  Future<void> stop() {
    super.stop();
    _disposer.cancel();

    Log.info('AreaDetector stopped.');
    return null;
  }

  final Disposer _disposer = Disposer();
}
