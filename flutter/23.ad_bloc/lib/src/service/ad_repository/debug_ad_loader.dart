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
    List<DebugDateTime> debugDateTimes = [];

    for (final rawCsv in _listOfRawCsv) {
      // Use a Csv Replayer to load the raw csv data and play it on
      // a stream. This stream is a single subscription stream, which mean
      // it only produces csv values if there is a subscriber. Stream can be
      // pause, resume or cancel.
      final csvReplayer = CsvReplayer(
        rawCsv.raw,
        initialTimeOffset: rawCsv.initialTimeOffset,
      );

      final Stream<Iterable<Ad>> ads$ = csvReplayer.csv$.flatMap((csvRow) {
        final ads = _csvToAds(csvRow);
        if (ads == null)
          return Stream.empty();
        else
          return Stream.value(ads);
      });

      debugDateTimes.add(DebugDateTime(rawCsv.name, rawCsv.dateTime, ads$));
    }

    return debugDateTimes;
  }

  /// Convert csv data format to [Iterable<Ad>] value.
  /// Return null if the csv data is invalid.
  Iterable<Ad> _csvToAds(List<dynamic> csvRow) {
    if (csvRow.length < 1) return null;

    List<Ad> ads;
    try {
      ads = [];
      // find ad by ad id which derived from csv row
      for (final cell in csvRow) {
        // cell format is {ad-short-id}-{version}
        // e.g: de98a6c-1
        final splitted = cell.toString().split('-');
        final String adShortId = splitted[0].toString();
        final int adVersion = int.parse(splitted[1]);
        final ad = sampleAds.firstWhere(
            (ad) => ad.shortId == adShortId && ad.version == adVersion);
        ads.add(ad);
      }
    } catch (_) {
      return null;
    }

    return ads;
  }

  static final _listOfRawCsv = [
    _RawCsv(
      'Sep 12, 2020 at 11:16 am',
      DateTime.parse('2020-09-12 11:16:00'),
      sampleAdsCsv1,
      initialTimeOffset: 4794,
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
