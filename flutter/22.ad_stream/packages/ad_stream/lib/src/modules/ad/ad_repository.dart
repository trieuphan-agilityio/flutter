import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/models/ad.dart';
import 'package:ad_stream/src/models/targeting_value.dart';
import 'package:ad_stream/src/modules/ad/creative_downloader.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';

abstract class AdRepository {
  /// returns Ads that match the given Targeting Values
  List<Ad> getAds(TargetingValues values);

  /// returns downloaded Ads that match the given Targeting Values
  List<Ad> getReadyList(TargetingValues values);

  /// returns downloading Ads that match the given Targeting Values
  List<Ad> getDownloadingAds(TargetingValues values);

  /// List of keywords are associated to the ads in this repository.
  List<Keyword> getKeywords();

  /// Ads that has Creative has just been downloaded.
  Stream<Ad> get readyAd$;

  /// Ads that has Creative is downloading.
  Stream<Ad> get downloadingAd$;

  /// Ads that has just added to repository.
  Stream<Ad> get ad$;

  /// Keywords that has just collected.
  Stream<Keyword> get keywords$;

  /// [AdRepository] react to the change of Latitude, Longitude values.
  keepWatching(Stream<LatLng> latLng$);
}

class AdRepositoryImpl extends TaskService
    with ServiceMixin, TaskServiceMixin
    implements AdRepository {
  AdRepositoryImpl(this._creativeDownloader, this._config)
      : _ad$Controller = StreamController<Ad>(),
        _downloadingAd$Controller = StreamController<Ad>(),
        _readyAd$Controller = StreamController<Ad>();

  final CreativeDownloader _creativeDownloader;
  final Config _config;
  final StreamController<Ad> _ad$Controller;
  final StreamController<Ad> _downloadingAd$Controller;
  final StreamController<Ad> _readyAd$Controller;

  List<Ad> getAds(TargetingValues values) {
    return [];
  }

  List<Ad> getDownloadingAds(TargetingValues values) {
    return [];
  }

  List<Ad> getReadyList(TargetingValues values) {
    return [];
  }

  List<Keyword> getKeywords() {
    return [];
  }

  Stream<Ad> get ad$ {
    return _ad$Controller.stream;
  }

  Stream<Ad> get readyAd$ {
    return _readyAd$Controller.stream;
  }

  Stream<Ad> get downloadingAd$ {
    return _downloadingAd$Controller.stream;
  }

  Stream<Keyword> get keywords$ {
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

    //_creativeDownloader.downloadedCreative$.listen((creative) {});

    return null;
  }

  Future<void> stop() {
    super.stop();
    Log.info('AdRepository is stopping');
    return null;
  }

  Future<void> runTask() async {
    await _getAds();
    Log.info('AdRepository is fetching ads with $_currentLatLng');
    return null;
  }

  /// Save the latest value of from LatLng stream.
  /// Whenever call AdClientApi, this value would be sent to the Ad Server.
  LatLng _currentLatLng;
}
