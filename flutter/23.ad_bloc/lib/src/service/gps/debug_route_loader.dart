import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/model.dart';

import '../csv_replayer.dart';
import 'debug_route.dart';
import 'sample_data.dart';

class DebugRouteLoader {
  factory DebugRouteLoader.singleton() {
    if (_shared == null) _shared = DebugRouteLoader._();
    return _shared;
  }
  static DebugRouteLoader _shared;
  DebugRouteLoader._();

  /// load routes. The raw data can be persisted in storage, it supposes
  /// to expect return type is [Future] here.
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

    return Future.value(routes);
  }

  /// Convert csv data format to [LatLng] value.
  /// Return null if the csv data is invalid.
  LatLng _csvToLatLng(List<dynamic> csvRow) {
    if (csvRow.length != 2) return null;

    double lat;
    double lng;
    try {
      lat = csvRow[0];
      lng = csvRow[1];
    } catch (_) {
      return null;
    }

    return LatLng(lat, lng);
  }

  static const _listOfRawCsv = [
    _RawCsv(
      '496NgoQuyen_604NuiThanh',
      'from 496 Ngo Quyen to 604 Nui Thanh',
      sampleRouteCsv1,
      initialTimeOffset: 52726,
    ),
    _RawCsv(
      '10ChauThuongVan_151NguyenHuuDat',
      'from 10 Chau Thuong Van to 151 Nguyen Huu Dat',
      sampleRouteCsv2,
      initialTimeOffset: 10971,
    ),
    _RawCsv(
      '10XuanThuy_218XuanThuy',
      'from 10 Xuan Thuy to 218 Xuan Thuy',
      sampleRouteCsv3,
      initialTimeOffset: 30300,
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
