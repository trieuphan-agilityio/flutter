import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/src/model/ad.dart';
import 'package:ad_bloc/src/model/creative.dart';
import 'package:ad_bloc/src/model/targeting_value.dart';
import 'package:ad_bloc/src/model/gps.dart';
import 'package:ad_bloc/src/model/trip.dart';
import 'package:ad_bloc/src/service/ad_repository/ad_api_client.dart';
import 'package:ad_bloc/src/service/ad_repository/ad_repository.dart';
import 'package:ad_bloc/src/service/ad_repository/creative_downloader.dart';
import 'package:ad_bloc/src/service/face_detector.dart';
import 'package:ad_bloc/src/service/gps/gps_controller.dart';
import 'package:ad_bloc/src/service/permission_controller.dart';
import 'package:ad_bloc/src/service/power_provider.dart';
import 'package:ad_bloc/src/service/service.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler/permission_handler.dart';

export 'utils/permission_plugin.dart';

/// A zero-millisecond timer should wait until after all microtasks.
Future flushMicrotasks() => Future.delayed(Duration.zero);

const sampleVideoCreatives = [
  VideoCreative(
    id: '8d3b4e94-c27f-c4fe-9f31-75a69f45bee4',
    urlPath: '/faker/nulla_vivamus_dictum_suspendisse_aliquet.mp4',
    filePath: null,
    format: 'mp4',
    videoLength: 34,
    fileSize: 106722,
  ),
];

const sampleImageCreatives = [
  ImageCreative(
    id: '18e8ac00-c533-185b-4c55-e90e51384fb1',
    urlPath: '/faker/vestibulum_leo_quam_mi_pellentesque.jpg',
    filePath: null,
  ),
  ImageCreative(
    id: 'f9f3ce57-5c72-36d0-2960-e218eeee1e89',
    urlPath: '/faker/dictum_nascetur_dictum_amet_iaculis.jpg',
    filePath: null,
  ),
];

final sampleCreatives = [
  ...sampleVideoCreatives,
  ...sampleImageCreatives,
];

final sampleAds = [
  Ad(
    id: 'cf135d3a-4d95-6d0e-e904-48349e9e8c67',
    creative: sampleVideoCreatives[0],
    timeBlocks: 1,
    canSkipAfter: 6,
    targetingKeywords: [const Keyword('varius')],
    targetingAreas: [const Area('Da Nang')],
    targetingGenders: [PassengerGender.female],
    targetingAgeRanges: [const PassengerAgeRange(24, 38)],
    version: 0,
    createdAt: 1597286050010,
    lastModifiedAt: 1597286050010,
  ),
  Ad(
      id: '4479f226-e290-15b3-6ca3-5608a96bb67c',
      creative: sampleImageCreatives[0],
      timeBlocks: 1,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('placerat'),
        Keyword('ipsum'),
        Keyword('diam'),
        Keyword('fames'),
        Keyword('sapien'),
        Keyword('curabitur'),
        Keyword('facilisis'),
        Keyword('egestas')
      ],
      targetingAreas: [Area('Da Nang')],
      targetingGenders: [PassengerGender.female],
      targetingAgeRanges: [const PassengerAgeRange(24, 38)],
      version: 0,
      createdAt: 1597286050010,
      lastModifiedAt: 1597286050010),
  Ad(
      id: '1ab33a02-6374-8861-5344-9c74223003f3',
      creative: sampleImageCreatives[1],
      timeBlocks: 4,
      canSkipAfter: 6,
      targetingKeywords: [
        Keyword('nisi'),
        Keyword('imperdiet'),
        Keyword('cras'),
        Keyword('eleifend'),
        Keyword('urna'),
        Keyword('semper'),
        Keyword('mi'),
        Keyword('ipsum')
      ],
      targetingAreas: [Area('Da Nang')],
      targetingGenders: [PassengerGender.female],
      targetingAgeRanges: [const PassengerAgeRange(24, 38)],
      version: 0,
      createdAt: 1597286050010,
      lastModifiedAt: 1597286050010),
];

class MockGpsAdapter implements GpsAdapter {
  final Stream<LatLng> latLng$;

  MockGpsAdapter(this.latLng$);

  List<GpsOptions> buildStreamCalledArgs = [];
  Future<Stream<LatLng>> buildStream(GpsOptions options) async {
    buildStreamCalledArgs.add(options);
    return this.latLng$;
  }
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

class MockAdRepository with ServiceMixin implements AdRepository {
  MockAdRepository() : controller = StreamController.broadcast();

  final StreamController<Iterable<Ad>> controller;

  Stream<Iterable<Ad>> get ads$ => controller.stream;

  set ads(Iterable<Ad> ads) {
    controller.add(ads);
  }

  List<LatLng> changeLocationCalledArgs = [];
  changeLocation(LatLng latLng) {
    changeLocationCalledArgs.add(latLng);
  }

  Future<List<Keyword>> getKeywords() async {
    return [];
  }
}

class MockGpsController with ServiceMixin implements GpsController {
  MockGpsController(this.initial$)
      : assert(!initial$.isBroadcast),
        controller = StreamController.broadcast();

  final Stream<LatLng> initial$;
  final StreamController<LatLng> controller;

  List<GpsOptions> changeGpsOptionsCalledArgs = [];

  changeGpsOptions(GpsOptions options) {
    changeGpsOptionsCalledArgs.add(options);
  }

  Stream<LatLng> get latLng$ => controller.stream;

  @override
  start() async {
    super.start();
    disposer.autoDispose(initial$.listen(controller.add));
  }
}

class MockPermissionController
    with ServiceMixin
    implements PermissionController {
  MockPermissionController(this.initial$);

  final Stream<bool> initial$;

  Stream<bool> get isAllowed$ => initial$;

  @override
  List<Permission> get permissions => [];
}

class MockPowerProvider with ServiceMixin implements PowerProvider {
  MockPowerProvider(this.initial$);

  final Stream<bool> initial$;

  Stream<bool> get isStrong$ => initial$;
}

class MockFaceDetector implements FaceDetector {
  List<Face> faces;

  List<Photo> detectCalledArgs = [];
  Future<Iterable<Face>> detect(Photo photo) async {
    detectCalledArgs.add(photo);
    return faces;
  }
}
