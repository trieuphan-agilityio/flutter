import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/ad/ad_database.dart';

class MockAdDatabase implements AdDatabase {
  List<Ad> _ads = [];

  Future<Ad> saveCreative(Creative creative) {
    return null;
  }

  Future<List<Ad>> getAds() async {
    return _ads;
  }

  Future<void> saveAds(List<Ad> ads) async {
    _ads = ads;
    return null;
  }

  Future<void> removeAds(List<String> adIds) {
    Log.info('MockAdDatabase removed ${adIds.length} ads.');
    return null;
  }
}
