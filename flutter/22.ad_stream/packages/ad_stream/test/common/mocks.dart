import 'dart:async';

import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/models/targeting_value.dart';
import 'package:ad_stream/src/modules/ad/ad_api_client.dart';
import 'package:ad_stream/src/modules/ad/creative_downloader.dart';
import 'package:ad_stream/src/modules/base/service.dart';
import 'package:ad_stream/src/modules/gps/gps_controller.dart';
import 'package:ad_stream/src/modules/gps/gps_options.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/permission/permission_state.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:ad_stream/src/modules/storage/pref_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class MockPrefStoreWriting extends Mock implements PrefStoreWriting {}

class MockGpsAdapter implements GpsAdapter {
  List<GpsOptions> calledArgs = [];

  final Stream<LatLng> latLng$;

  MockGpsAdapter(this.latLng$);

  @override
  Stream<LatLng> buildStream(GpsOptions options) {
    calledArgs.add(options);
    return this.latLng$;
  }
}

class MockPowerProvider with ServiceMixin implements PowerProvider {
  final Stream<PowerState> _state$;

  MockPowerProvider(this._state$);

  Stream<PowerState> get state$ => _state$;
}

class MockPermissionController
    with ServiceMixin
    implements PermissionController {
  final Stream<PermissionState> _state$;

  MockPermissionController(this._state$) {
    _state$.listen((newState) => _state = newState);
  }

  List<Permission> get permissions => [];

  Stream<PermissionState> get state$ => _state$;

  PermissionState get state => _state;

  PermissionState _state;
}

class MockAdApiClient extends Mock implements AdApiClient {}

class MockCreativeDownloader implements CreativeDownloader {
  MockCreativeDownloader() : _controller = StreamController.broadcast();

  StreamController<Creative> _controller;

  List<Creative> cancelDownloadCalledArgs = [];
  cancelDownload(Creative creative) {
    cancelDownloadCalledArgs.add(creative);
  }

  List<Creative> downloadCalledArgs = [];
  download(Creative creative) {
    downloadCalledArgs.add(creative);
  }

  downloadSuccess(Creative creative) {
    if (creative is VideoCreative) {
      _controller.add(
        creative.copyWith(filePath: 'mock/file.mp4'),
      );
    } else if (creative is HtmlCreative) {
      _controller.add(
        creative.copyWith(filePath: 'mock/folder'),
      );
    } else if (creative is ImageCreative) {
      _controller.add(
        creative.copyWith(filePath: 'mock/file.jpg'),
      );
    } else if (creative is YoutubeCreative) {
      _controller.add(creative);
    }
  }

  Stream<Creative> get downloaded$ => _controller.stream;
}
