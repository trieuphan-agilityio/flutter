import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/model.dart';

import '../csv_replayer.dart';
import 'debug_date_time.dart';
import 'sample_data.dart';

class DebugAdLoader {
  factory DebugAdLoader.singleton() {
    if (_shared == null) _shared = DebugAdLoader._();
    return _shared;
  }
  DebugAdLoader._();
  static DebugAdLoader _shared;

  Future<List<DebugDateTime>> load() async {
    List<DebugDateTime> debugDateTime = [];

    for (final rawCsv in _listOfRawCsv) {
      // Use a Csv Replayer to load the raw csv data and play it on
      // a stream. This stream is a single subscription stream, which mean
      // it only produces csv values if there is a subscriber. Stream can be
      // pause, resume or cancel.
      final csvReplayer = CsvReplayer(
        rawCsv.raw,
        initialTimeOffset: rawCsv.initialTimeOffset,
      );

      final Stream<Iterable<Ad>> ads$ = csvReplayer.csv$.flatMap((csv) {
        final ads = _csvToAds(csv);
        if (ads == null)
          return Stream.empty();
        else
          return Stream.value(ads);
      });

      debugDateTime.add(DebugDateTime(rawCsv.name, rawCsv.dateTime, ads$));
    }

    return [];
  }

  /// Convert csv data format to [Iterable<Ad>] value.
  /// Return null if the csv data is invalid.
  Iterable<Ad> _csvToAds(List<dynamic> csv) {
    if (csv.length < 1) return null;

    List<Ad> ads;
    try {
      // find ad by ad id from csv row and add to the list
      ads = [];
    } catch (_) {
      return null;
    }

    return ads;
  }

  static final _listOfRawCsv = [
    _RawCsv(
      'Sep 12, 2020 at 11:16 am',
      DateTime.now(),
      sampleAdsCsv1,
      initialTimeOffset: 0,
    ),
  ];
}

class _RawCsv {
  final String name;
  final DateTime dateTime;
  final String raw;
  final int initialTimeOffset;

  const _RawCsv(
    this.name,
    this.dateTime,
    this.raw, {
    this.initialTimeOffset = 0,
  });
}
