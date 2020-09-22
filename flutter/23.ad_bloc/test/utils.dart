import 'package:ad_bloc/src/model/ad.dart';
import 'package:ad_bloc/src/model/creative.dart';
import 'package:ad_bloc/src/model/targeting_value.dart';
import 'package:ad_bloc/src/model/gps.dart';
import 'package:ad_bloc/src/service/ad_api_client.dart';
import 'package:ad_bloc/src/service/creative_downloader.dart';
import 'package:ad_bloc/src/service/gps/gps_controller.dart';
import 'package:ad_bloc/src/service/permission_controller.dart';
import 'package:ad_bloc/src/service/power_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler/permission_handler.dart';

/// A zero-millisecond timer should wait until after all microtasks.
Future flushMicrotasks() => Future.delayed(Duration.zero);

class MockAdApiClient implements AdApiClient {
  Iterable<Ad> ads = [];

  List<LatLng> getAdsCalledArgs = [];
  Future<List<Ad>> getAds(LatLng latLng) async {
    getAdsCalledArgs.add(latLng);
    return ads;
  }
}

class MockCreativeDownloader implements CreativeDownloader {
  final Stream<Creative> initial$;

  MockCreativeDownloader(this.initial$);

  List<Creative> cancelDownloadCalledArgs = [];
  cancelDownload(Creative creative) {
    cancelDownloadCalledArgs.add(creative);
  }

  List<Creative> downloadCalledArgs = [];
  download(Creative creative) {
    downloadCalledArgs = [];
  }

  Stream<Creative> get downloaded$ => initial$;
}

class MockGpsController implements GpsController {
  final Stream<LatLng> initial$;
  MockGpsController(this.initial$);

  List<GpsOptions> changeGpsOptionsCalledArgs = [];

  changeGpsOptions(GpsOptions options) {
    changeGpsOptionsCalledArgs.add(options);
  }

  Stream<LatLng> get latLng$ => initial$;

  int startCalled = 0;
  start() => startCalled++;

  int stopCalled = 0;
  stop() => stopCalled++;
}

class MockPermissionController implements PermissionController {
  final Stream<bool> initial$;
  MockPermissionController(this.initial$);

  Stream<bool> get isAllowed$ => initial$;

  @override
  List<Permission> get permissions => [];

  int startCalled = 0;
  start() => startCalled++;

  int stopCalled = 0;
  stop() => stopCalled++;
}

class MockPowerProvider implements PowerProvider {
  final Stream<bool> initial$;
  MockPowerProvider(this.initial$);

  Stream<bool> get isStrong$ => initial$;

  int startCalled = 0;
  start() => startCalled++;

  int stopCalled = 0;
  stop() => stopCalled++;
}
