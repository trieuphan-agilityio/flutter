import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/models/ad.dart';
import 'package:ad_stream/src/models/targeting_value.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';

abstract class AdRepository {
  /// returns Ads that match the given Targeting Values
  List<Ad> getAds(TargetingValues values);

  /// returns downloaded Ads that match the given Targeting Values
  List<Ad> getReadyList(TargetingValues values);

  /// returns downloading Ads that match the given Targeting Values
  List<Ad> getDownloadingAds(TargetingValues values);

  /// List of keywords are associated to the ads in this repository.
  List<Keywords> getKeywords();

  /// Ads that has Creative has just been downloaded.
  Stream<Ad> readyAd$();

  /// Ads that has Creative is downloading.
  Stream<Ad> downloadingAd$();

  /// Ads that has just added to repository.
  Stream<Ad> ad$();

  /// Keywords that has just collected.
  Stream<Keywords> keywords$();

  /// [AdRepository] react to the change of Latitude, Longitude values.
  keepWatching(Stream<LatLng> latLng$);
}

class AdRepositoryImpl extends TaskService
    with ServiceMixin, TaskServiceMixin
    implements AdRepository {
  AdRepositoryImpl(this._config);

  Config _config;

  List<Ad> getAds(TargetingValues values) {
    return [];
  }

  List<Ad> getDownloadingAds(TargetingValues values) {
    return [];
  }

  List<Ad> getReadyList(TargetingValues values) {
    return [];
  }

  List<Keywords> getKeywords() {
    return [];
  }

  Stream<Ad> ad$() {
    return Stream.empty();
  }

  Stream<Ad> readyAd$() {
    return Stream.empty();
  }

  Stream<Ad> downloadingAd$() {
    return Stream.empty();
  }

  Stream<Keywords> keywords$() {
    return Stream.empty();
  }

  keepWatching(Stream<LatLng> latLng$) {
    latLng$.listen((newValue) {
      _currentLatLng = newValue;
    });
  }

  _getAds() {
    Log.info('AdRepository get ads with $_currentLatLng');
  }

  /// ==========================================================================
  /// TaskService
  /// ==========================================================================

  int get defaultRefreshInterval => _config.defaultAdRepositoryRefreshInterval;

  Future<void> start() {
    super.start();
    Log.info('AdRepository is starting');
    return null;
  }

  Future<void> stop() {
    super.stop();
    Log.info('AdRepository is stopping');
    return null;
  }

  Future<void> runTask() async {
    await _getAds();
    return null;
  }

  /// Save the latest value of from LatLng stream.
  /// Whenever call AdClientApi, this value would be sent to the Ad Server.
  LatLng _currentLatLng;
}
