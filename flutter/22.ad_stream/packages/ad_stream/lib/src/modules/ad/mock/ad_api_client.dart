import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/models/ad.dart';
import 'package:ad_stream/src/models/targeting_value.dart';
import 'package:ad_stream/src/modules/ad/ad_api_client.dart';
import 'package:ad_stream/src/modules/ad/mock/ad.dart';

class MockAdApiClient implements AdApiClient {
  /// Keep track the current version of ads.
  ///
  /// It helps to simulate the updating behavior by increasing ad version every
  /// time it's served again.
  Map<String, int> _versionMap = {};

  List<Ad> _previousAdResults = [];

  /// [getAds] simulate Ads distribution, it allows to verify if there is new,
  /// updated and removed ads.
  ///
  /// slice 5 -> 10 items from [mockAds] for each time it's called.
  Future<List<Ad>> getAds(LatLng latLng) async {
    // 66% use previous result, which mean the list don't change.
    if (faker.randomGenerator.integer(3) % 2 != 0) {
      if (_previousAdResults.length > 0) {
        return _previousAdResults;
      }
    }

    final numOfItems = faker.randomGenerator.integer(10, min: 5);
    final maxStartOffset = mockAds.length - numOfItems;
    final randomStartOffset = faker.randomGenerator.integer(maxStartOffset);

    final randomAds =
        mockAds.sublist(randomStartOffset, randomStartOffset + numOfItems);

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
