import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/ad/ad_database.dart';
import 'package:ad_stream/src/modules/ad/mock/ad.dart';

class MockAdDatabase implements AdDatabase {
  Future<Ad> save(Creative creative) {
    return null;
  }

  bool _calledOnce = false;

  Future<List<Ad>> getAds() async {
    if (_calledOnce) {
      return mockAds;
    } else {
      _calledOnce = true;
      return [];
    }
  }
}
