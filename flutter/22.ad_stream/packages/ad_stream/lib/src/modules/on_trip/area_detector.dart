import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/config.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:rxdart/rxdart.dart';

abstract class AreaDetector implements Service {
  Stream<List<Area>> get areas$;
}

class AreaDetectorImpl with ServiceMixin implements AreaDetector {
  final StreamController<List<Area>> _controller;
  final Stream<LatLng> _latLng$;
  final AreaConfigProvider _configProvider;

  AreaDetectorImpl(this._latLng$, this._configProvider)
      : _controller = BehaviorSubject<List<Area>>();

  Stream<List<Area>> get areas$ => _controller.stream;

  Future<List<Area>> _detectAreas(LatLng latLng) async {
    // FIXME
    return [Area('Da Nang')];
  }

  @override
  Future<void> start() {
    super.start();

    _configProvider.areaConfig$.listen((config) {
      subscription?.cancel();

      subscription = this
          ._latLng$
          .sampleTime(Duration(seconds: config.refreshInterval))
          .listen((latLng) async {
        final areas = await _detectAreas(latLng);
        _controller.add(areas);

        Log.debug('AreaDetector detected'
            ' ${areas.length} ${areas.length > 1 ? "areas" : "area"}.');
      });

      disposer.autoDispose(subscription);
    });

    return null;
  }

  StreamSubscription<LatLng> subscription;
}
