import 'package:ad_stream/src/models/ad.dart';
import 'package:ad_stream/src/models/targeting_value.dart';
import 'package:ad_stream/src/modules/ad/ad_api_client.dart';
import 'package:ad_stream/src/modules/ad/mock/ad.dart';

class MockAdApiClient implements AdApiClient {
  Future<List<Ad>> getAds(LatLng latLng) async {
    return mockAds;
  }
}
