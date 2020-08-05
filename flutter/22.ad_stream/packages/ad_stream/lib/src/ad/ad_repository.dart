import 'package:ad_stream/src/ad/ad.dart';
import 'package:ad_stream/src/ad/targeting_value.dart';

abstract class AdRepository {
  /// All creatives had been downloaded.
  Stream<List<Ad>> readyAds();

  /// For debugger
  Stream<List<Ad>> downloadingAds();
  Stream<List<Ad>> ads();

  /// returns downloaded Ads
  List<Ad> getReadyList(TargetingValues values);
}

class AdRepositoryImpl implements AdRepository {
  @override
  Stream<List<Ad>> ads() {
    // TODO: implement creative
    throw UnimplementedError();
  }

  @override
  Stream<List<Ad>> downloadingAds() {
    // TODO: implement downloadingAds
    throw UnimplementedError();
  }

  @override
  List<Ad> getReadyList(TargetingValues values) {
    // TODO: implement getReadyList
    throw UnimplementedError();
  }

  @override
  Stream<List<Ad>> readyAds() {
    // TODO: implement readyAds
    throw UnimplementedError();
  }
}
