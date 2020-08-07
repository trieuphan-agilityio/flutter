import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/models/ad.dart';
import 'package:ad_stream/src/models/targeting_value.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';

abstract class AdRepository {
  /// returns downloaded Ads that match the given Targeting Values
  List<Ad> getReadyList(TargetingValues values);

  /// returns downloading Ads that match the given Targeting Values
  List<Ad> getDownloadingAds(TargetingValues values);

  /// returns Ads that match the given Targeting Values
  List<Ad> getAds(TargetingValues values);

  /// List of keywords are associated to the ads in this repository.
  List<Keywords> getKeywords();

  /// Ads that has Creative has just been downloaded.
  Stream<Ad> readyAdsStream();

  /// Ads that has Creative is downloading.
  Stream<Ad> downloadingAdsStream();

  /// Ads that has just added to repository.
  Stream<Ad> adsStream();

  /// Keywords that has just collected.
  Stream<Keywords> keywordsStream();
}

class AdRepositoryImpl extends Service
    with ServiceMixin
    implements AdRepository {
  @override
  List<Ad> getAds(TargetingValues values) {
    return [];
  }

  @override
  List<Ad> getDownloadingAds(TargetingValues values) {
    return [];
  }

  @override
  List<Ad> getReadyList(TargetingValues values) {
    return [];
  }

  @override
  List<Keywords> getKeywords() {
    return [];
  }

  @override
  Stream<Ad> adsStream() {
    return Stream.empty();
  }

  @override
  Stream<Ad> readyAdsStream() {
    return Stream.empty();
  }

  @override
  Stream<Ad> downloadingAdsStream() {
    return Stream.empty();
  }

  @override
  Stream<Keywords> keywordsStream() {
    return Stream.empty();
  }

  /// ==========================================================================
  /// Service
  /// ==========================================================================

  Future<void> start() {
    Log.info('AdRepository is starting');
    return null;
  }

  Future<void> stop() {
    Log.info('AdRepository is stopping');
    return null;
  }
}
