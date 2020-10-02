import 'package:ad_bloc/model.dart';
import 'package:ad_bloc/src/model/faker/fake_ads.dart';
import 'package:ad_bloc/src/service/debugger_builder.dart';
import 'package:faker/faker.dart';

/// Client library that help to communicate with Ad Server
abstract class AdApiClient {
  /// Get all the ads that are targeting to this [LatLng] value.
  Future<Iterable<Ad>> getAds(LatLng latLng);
}

class FakeAdApiClient implements AdApiClient {
  final AdApiClientDebugger _debugger;

  FakeAdApiClient({AdApiClientDebugger debugger}) : _debugger = debugger {
    _debugger?.ads$?.listen((ads) => _debuggerValue = ads);
  }

  /// persist the ads result from debugger's stream
  Iterable<Ad> _debuggerValue = const [];

  /// Keep track the current version of ads.
  ///
  /// It helps to simulate the updating behavior by increasing ad version every
  /// time it's served again.
  Map<String, int> _versionMap = {};

  List<Ad> _previousAdResults = [];

  static const minNumOfItemsPerBatch = 50;
  static const maxNumOfItemsPerBatch = 100;

  Future<Iterable<Ad>> getAds(LatLng latLng) async {
    if (_debugger == null) {
      return _doGetAds(latLng);
    }

    // use value from debugger's stream
    return _debuggerValue;
  }

  /// [getAds] simulate Ads distribution, it allows to verify if there is new,
  /// updated and removed ads.
  ///
  /// slice [minNumOfItemsPerBatch] -> [maxNumOfItemsPerBatch] items from
  /// [mockAds] for each time it's called.
  Future<Iterable<Ad>> _doGetAds(LatLng latLng) async {
    // 90% use previous result, which mean the list don't change.
    if (faker.randomGenerator.integer(10) > 1) {
      if (_previousAdResults.length > 0) {
        return _previousAdResults;
      }
    }

    final numOfItems = faker.randomGenerator.integer(
      maxNumOfItemsPerBatch,
      min: minNumOfItemsPerBatch,
    );
    final maxStartOffset = fakeAds.length - numOfItems;
    final randomStartOffset = faker.randomGenerator.integer(maxStartOffset);

    final randomAds =
        fakeAds.sublist(randomStartOffset, randomStartOffset + numOfItems);

    List<Ad> adsToReturn = [];

    for (final ad in randomAds) {
      // increase version in the map or add new if needs.
      if (_versionMap.containsKey(ad.id)) {
        _versionMap[ad.id] = _versionMap[ad.id] + 1;
      } else {
        _versionMap[ad.id] = ad.version;
      }

      // get new ad that have version was updated.
      adsToReturn.add(ad.copyWith(version: _versionMap[ad.id]));
    }

    _previousAdResults = adsToReturn;

    return adsToReturn;
  }
}
