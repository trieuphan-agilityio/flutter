import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/models/ad.dart';
import 'package:ad_stream/src/models/targeting_value.dart';
import 'package:ad_stream/src/modules/service_manager/service_manager.dart';

const String _kAdRepositoryIdentifier = 'AD_REPOSITORY';

abstract class AdRepository implements ManageableService {
  /// returns downloaded Ads that match the given Targeting Values
  List<Ad> getReadyList(TargetingValues values);

  /// returns downloading Ads that match the given Targeting Values
  List<Ad> getDownloadingAds(TargetingValues values);

  /// returns Ads that match the given Targeting Values
  List<Ad> getAds(TargetingValues values);

  /// List of keywords were associated to the ads.
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

class AdRepositoryImpl implements AdRepository {
  @override
  List<Ad> getAds(TargetingValues values) {
    // TODO: implement getAds
    return [];
  }

  @override
  List<Ad> getDownloadingAds(TargetingValues values) {
    // TODO: implement getDownloadingAds
    return [];
  }

  @override
  List<Ad> getReadyList(TargetingValues values) {
    // TODO: implement getReadyList
    throw [];
  }

  @override
  List<Keywords> getKeywords() {
    // TODO: implement getKeywords
    return [];
  }

  @override
  Stream<Ad> adsStream() {
    // TODO: implement adsStream
    return Stream.empty();
  }

  @override
  Stream<Ad> readyAdsStream() {
    // TODO: implement readyAdsStream
    throw UnimplementedError();
  }

  @override
  Stream<Ad> downloadingAdsStream() {
    // TODO: implement downloadingAdsStream
    return Stream.empty();
  }

  @override
  Stream<Keywords> keywordsStream() {
    // TODO: implement keywordsStream
    return Stream.empty();
  }

  /// ==========================================================================
  /// ManageableService
  /// ==========================================================================

  String get identifier => _kAdRepositoryIdentifier;

  Future<void> start() {
    Log.info('AdRepository is starting');
    return null;
  }

  Future<void> stop() {
    Log.info('AdRepository is stopping');
    return null;
  }
}
