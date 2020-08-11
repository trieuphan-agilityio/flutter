import 'package:ad_stream/models.dart';

/// Client library that help to communicate
abstract class AdApiClient {
  List<Ad> getAds(int lat, int lng, {int page = 0, int pageSize = 10});
}

class AdApiClientImpl implements AdApiClient {
  List<Ad> getAds(int lat, int lng, {int page = 0, int pageSize = 10}) {
    return [];
  }
}
