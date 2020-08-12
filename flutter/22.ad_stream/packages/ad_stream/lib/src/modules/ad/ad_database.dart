import 'package:ad_stream/models.dart';

abstract class AdDatabase {
  Future<Ad> save(Creative creative) {
    return null;
  }

  Future<List<Ad>> getAds() async {
    return [];
  }
}
