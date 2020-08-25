import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/common/csv_replayer.dart';
import 'package:ad_stream/src/modules/gps/debugger/debug_route.dart';
import 'package:ad_stream/src/modules/gps/mock/sample_data.dart';
import 'package:rxdart/rxdart.dart';

abstract class DebugRouteLoader {
  /// load routes. The raw data can be persisted in storage, it supposes
  /// to expect return type is [Future] here.
  Future<List<DebugRoute>> load();
}

class DebugRouteLoaderImpl implements DebugRouteLoader {
  Future<List<DebugRoute>> load() async {
    List<DebugRoute> routes = [];

    for (final rawCsv in _listOfRawCsv) {
      // Use a Csv Replayer to load the raw csv data and play it on
      // a stream. This stream is a single subscription stream, which mean
      // it only produces csv values if there is a subscriber. Stream can be
      // pause, resume or cancel.
      final csvReplayer = CsvReplayer(
        rawCsv.raw,
        initialTimeOffset: rawCsv.initialTimeOffset,
      );

      final Stream<LatLng> latLng$ = csvReplayer.csv$.flatMap((csv) {
        final latLng = _csvToLatLng(csv);
        if (latLng == null)
          return Stream.empty();
        else
          return Stream.value(latLng);
      });

      routes.add(DebugRoute(rawCsv.id, rawCsv.name, latLng$));
    }

    Log.debug('DebugRouteLoaderImpl loaded ${routes.length} routes.');

    return Future.value(routes);
  }

  /// Convert csv data format to [LatLng] value.
  /// Return null if the csv data is invalid.
  LatLng _csvToLatLng(List<dynamic> csv) {
    if (csv.length != 2) return null;

    double lat;
    double lng;
    try {
      lat = csv[0];
      lng = csv[1];
    } catch (_) {
      return null;
    }

    return LatLng(lat, lng);
  }

  static const _listOfRawCsv = [
    _RawCsv(
      '496NgoQuyen_604NuiThanh',
      '496 Ngo Quyen -> 604 Nui Thanh',
      sampleRouteCsv1,
      initialTimeOffset: 52726,
    ),
  ];
}

class _RawCsv {
  final String id;
  final String name;
  final String raw;
  final int initialTimeOffset;

  const _RawCsv(
    this.id,
    this.name,
    this.raw, {
    this.initialTimeOffset = 0,
  });
}
