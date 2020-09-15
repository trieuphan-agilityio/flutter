import 'dart:async';

import 'package:ad_stream/config.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/ad/ad_repository.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quiver/time.dart';

import '../common.dart';
import '../common/utils.dart';

main() {
  AdRepositoryImpl adRepository;

  MockAdApiClient mockAdApiClient;
  MockCreativeDownloader mockCreativeDownloader;
  ConfigProvider configProvider;
  StreamController<LatLng> latLng$Controller;

  List<List<Ad>> emittedValues;
  List<String> errors;
  bool isDone;

  /// simulate location is changed while fetching ads
  locationChanged(LatLng latLng) {
    latLng$Controller.add(latLng);
  }

  group('AdRepostoryImpl', () {
    setUp(() {
      mockAdApiClient = MockAdApiClient();
      mockCreativeDownloader = MockCreativeDownloader();

      configProvider = ConfigProviderImpl();
      configProvider.config = Config(
        defaultAdRepositoryRefreshInterval: 15,
        defaultAd: null,
        creativeBaseUrl: 'http://localhost:8080/public/creatives/',
      );

      latLng$Controller = StreamController.broadcast();

      adRepository = AdRepositoryImpl(
        mockAdApiClient,
        mockCreativeDownloader,
        configProvider,
      );

      adRepository.keepWatching(latLng$Controller.stream);

      emittedValues = [];
      errors = [];
      isDone = false;

      adRepository.ads$.listen(
        emittedValues.add,
        onError: errors.add,
        onDone: () => isDone = true,
      );
    });

    tearDown(() {
      latLng$Controller.close();
    });

    test('fetch no ads', () async {
      when(mockAdApiClient.getAds(null)).thenAnswer(
        (_) => Future<List<Ad>>.value([]),
      );

      adRepository.start();
      await flushMicrotasks();

      expect(emittedValues, [[]]);
      expect(errors, []);
      expect(isDone, false);
    });

    test('download new ads', () async {
      when(mockAdApiClient.getAds(null)).thenAnswer(
        (_) => Future<List<Ad>>.value(_sampleAds),
      );

      fakeAsync((async) {
        adRepository.start();
        async.elapse(aSecond);

        expect(emittedValues, [[]]);
        expect(errors, []);
        expect(mockCreativeDownloader.downloadCalledArgs, _sampleCreatives);

        mockCreativeDownloader.downloadSuccess(_sampleCreatives[0]);
        async.elapse(aSecond);

        expect(emittedValues.length, 2);
        expect(emittedValues[1], [
          _sampleAds[0].copyWith(
            creative: _sampleVideoCreatives[0].copyWith(
              filePath: 'mock/file.mp4',
            ),
          ),
        ]);
        expect(errors, []);

        mockCreativeDownloader.downloadSuccess(_sampleCreatives[1]);
        mockCreativeDownloader.downloadSuccess(_sampleCreatives[2]);
        async.elapse(aSecond);

        expect(emittedValues.length, 4);
        expect(emittedValues[2], [
          _sampleAds[0].copyWith(
            creative: _sampleVideoCreatives[0].copyWith(
              filePath: 'mock/file.mp4',
            ),
          ),
          _sampleAds[1].copyWith(
            creative: _sampleImageCreatives[0].copyWith(
              filePath: 'mock/file.jpg',
            ),
          ),
        ]);
        expect(emittedValues[3], [
          _sampleAds[0].copyWith(
            creative: _sampleVideoCreatives[0].copyWith(
              filePath: 'mock/file.mp4',
            ),
          ),
          _sampleAds[1].copyWith(
            creative: _sampleImageCreatives[0].copyWith(
              filePath: 'mock/file.jpg',
            ),
          ),
          _sampleAds[2].copyWith(
            creative: _sampleImageCreatives[1].copyWith(
              filePath: 'mock/file.jpg',
            ),
          ),
        ]);
        expect(errors, []);
        expect(isDone, false);
      });
    });

    test('remove ad', () async {
      // the fisrt time it get ads without location info
      when(mockAdApiClient.getAds(null)).thenAnswer(
        (_) => Future<List<Ad>>.value(_sampleAds),
      );

      // then few seconds later, when background task starts running, it supposes
      // to send get ads request with location info is attached.
      when(mockAdApiClient.getAds(LatLng(53.817198, -2.417717))).thenAnswer(
        (_) => Future<List<Ad>>.value([
          _sampleAds[0],
        ]),
      );

      fakeAsync((async) {
        adRepository.start();
        async.elapse(aSecond);

        expect(mockCreativeDownloader.downloadCalledArgs, _sampleCreatives);
        expect(emittedValues, [[]]);
        expect(errors, []);

        mockCreativeDownloader.downloadSuccess(_sampleCreatives[0]);
        mockCreativeDownloader.downloadSuccess(_sampleCreatives[1]);
        mockCreativeDownloader.downloadSuccess(_sampleCreatives[2]);
        async.elapse(aSecond);

        expect(emittedValues.length, 4);

        locationChanged(LatLng(53.817198, -2.417717));

        // wait for next background task to run
        async.elapse(Duration(seconds: 16));

        // expect no need to redownload
        expect(mockCreativeDownloader.downloadCalledArgs, _sampleCreatives);

        expect(emittedValues.length, 5);
        expect(emittedValues[4], [
          _sampleAds[0].copyWith(
            creative: _sampleVideoCreatives[0].copyWith(
              filePath: 'mock/file.mp4',
            ),
          ),
        ]);
      });
    });

    test('update ad', () {
      when(mockAdApiClient.getAds(null)).thenAnswer(
        (_) => Future<List<Ad>>.value([
          _sampleAds[0],
        ]),
      );

      when(mockAdApiClient.getAds(LatLng(53.817198, -2.417717))).thenAnswer(
        (_) => Future<List<Ad>>.value([
          _sampleAds[0].copyWith(timeBlocks: 2, version: 1),
        ]),
      );

      fakeAsync((async) {
        adRepository.start();
        async.elapse(aSecond);

        expect(
          mockCreativeDownloader.downloadCalledArgs,
          [_sampleCreatives[0]],
        );
        expect(emittedValues, [[]]);
        expect(errors, []);

        mockCreativeDownloader.downloadSuccess(_sampleCreatives[0]);
        async.elapse(aSecond);

        expect(emittedValues.length, 2);
        expect(emittedValues[1], [
          _sampleAds[0].copyWith(
            creative: _sampleVideoCreatives[0].copyWith(
              filePath: 'mock/file.mp4',
            ),
          )
        ]);

        locationChanged(LatLng(53.817198, -2.417717));

        // wait for next background task to run. The set up was updated refresh
        // interval to 15s, so it just ran 1 second ago.
        async.elapse(Duration(seconds: 16));

        // the updating ad was removed from the ready list.
        expect(emittedValues.length, 3);
        expect(emittedValues[2], []);

        // the updated ad is redownload.
        mockCreativeDownloader.downloadSuccess(_sampleCreatives[0]);
        async.elapse(aSecond);

        expect(
          mockCreativeDownloader.downloadCalledArgs,
          [
            _sampleCreatives[0],
            _sampleCreatives[0],
          ],
        );
        expect(emittedValues.length, 4);
        expect(emittedValues[3], [
          _sampleAds[0].copyWith(
            timeBlocks: 2,
            creative: _sampleVideoCreatives[0].copyWith(
              filePath: 'mock/file.mp4',
            ),
            version: 1,
          ),
        ]);
        expect(errors, []);
        expect(isDone, false);
      });
    });
  });
}

const _sampleVideoCreatives = [
  VideoCreative(
    id: '8d3b4e94-c27f-c4fe-9f31-75a69f45bee4',
    urlPath: '/faker/nulla_vivamus_dictum_suspendisse_aliquet.mp4',
    filePath: null,
    format: 'mp4',
    videoLength: 34,
    fileSize: 106722,
  ),
];

const _sampleImageCreatives = [
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

final _sampleCreatives = [
  ..._sampleVideoCreatives,
  ..._sampleImageCreatives,
];

final _sampleAds = [
  Ad(
    id: 'cf135d3a-4d95-6d0e-e904-48349e9e8c67',
    creative: _sampleVideoCreatives[0],
    timeBlocks: 1,
    canSkipAfter: 6,
    targetingKeywords: [const Keyword('varius')],
    targetingAreas: [const Area('Da Nang')],
    targetingGenders: [PassengerGender.female],
    targetingAgeRanges: [const PassengerAgeRange(24, 38)],
    version: 0,
    createdAt: DateTime.parse('2020-08-13 09:34:10.007672'),
    lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.007687'),
  ),
  Ad(
      id: '4479f226-e290-15b3-6ca3-5608a96bb67c',
      creative: _sampleImageCreatives[0],
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
      createdAt: DateTime.parse('2020-08-13 09:34:10.010174'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.010187')),
  Ad(
      id: '1ab33a02-6374-8861-5344-9c74223003f3',
      creative: _sampleImageCreatives[1],
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
      createdAt: DateTime.parse('2020-08-13 09:34:10.010354'),
      lastModifiedAt: DateTime.parse('2020-08-13 09:34:10.010369')),
];
