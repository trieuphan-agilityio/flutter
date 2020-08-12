import 'package:ad_stream/models.dart';

/// Client library that help to communicate with Ad Server
abstract class AdApiClient {
  /// Get all the ads that are targeting to this [LatLng] value.
  Future<List<Ad>> getAds(LatLng latLng);
}

class AdApiClientImpl implements AdApiClient {
  Future<List<Ad>> getAds(LatLng latLng) async {
    return [];
  }
}
