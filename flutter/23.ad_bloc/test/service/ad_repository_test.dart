import 'dart:async';

import 'package:ad_bloc/config.dart';
import 'package:ad_bloc/model.dart';
import 'package:ad_bloc/src/service/ad_repository/ad_repository.dart';
import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:quiver/time.dart';

import '../utils.dart';

main() {
  AdRepositoryImpl adRepository;

  MockAdApiClient mockAdApiClient;
  MockCreativeDownloader mockCreativeDownloader;
  ConfigProvider configProvider;

  List<List<Ad>> emittedValues;
  List<String> errors;
  bool isDone;

  /// simulate location is changed while fetching ads
  locationChanged(LatLng latLng) {
    adRepository.changeLocation(latLng);
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

      adRepository = AdRepositoryImpl(
        mockAdApiClient,
        mockCreativeDownloader,
        configProvider,
      );

      emittedValues = [];
      errors = [];
      isDone = false;

      adRepository.ads$.listen(
        emittedValues.add,
        onError: errors.add,
        onDone: () => isDone = true,
      );
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
        (_) => Future<List<Ad>>.value(sampleAds),
      );

      fakeAsync((async) {
        adRepository.start();
        async.elapse(aSecond);

        expect(emittedValues, [[]]);
        expect(errors, []);
        expect(mockCreativeDownloader.downloadCalledArgs, sampleCreatives);

        mockCreativeDownloader.downloadSuccess(sampleCreatives[0]);
        async.elapse(aSecond);

        expect(emittedValues.length, 2);
        expect(emittedValues[1], [
          sampleAds[0].copyWith(
            creative: sampleVideoCreatives[0].copyWith(
              filePath: 'mock/file.mp4',
            ),
          ),
        ]);
        expect(errors, []);

        mockCreativeDownloader.downloadSuccess(sampleCreatives[1]);
        mockCreativeDownloader.downloadSuccess(sampleCreatives[2]);
        async.elapse(aSecond);

        expect(emittedValues.length, 3);
        expect(emittedValues[2], [
          sampleAds[0].copyWith(
            creative: sampleVideoCreatives[0].copyWith(
              filePath: 'mock/file.mp4',
            ),
          ),
          sampleAds[1].copyWith(
            creative: sampleImageCreatives[0].copyWith(
              filePath: 'mock/file.jpg',
            ),
          ),
          sampleAds[2].copyWith(
            creative: sampleImageCreatives[1].copyWith(
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
        (_) => Future<List<Ad>>.value(sampleAds),
      );

      // then few seconds later, when background task starts running, it supposes
      // to send get ads request with location info is attached.
      when(mockAdApiClient.getAds(LatLng(53.817198, -2.417717))).thenAnswer(
        (_) => Future<List<Ad>>.value([
          sampleAds[0],
        ]),
      );

      fakeAsync((async) {
        adRepository.start();
        async.elapse(aSecond);

        expect(mockCreativeDownloader.downloadCalledArgs, sampleCreatives);
        expect(emittedValues, [[]]);
        expect(errors, []);

        mockCreativeDownloader.downloadSuccess(sampleCreatives[0]);
        mockCreativeDownloader.downloadSuccess(sampleCreatives[1]);
        mockCreativeDownloader.downloadSuccess(sampleCreatives[2]);
        async.elapse(aSecond);

        expect(emittedValues.length, 2);

        locationChanged(LatLng(53.817198, -2.417717));

        // wait for next background task to run
        async.elapse(Duration(seconds: 16));

        // expect no need to redownload
        expect(mockCreativeDownloader.downloadCalledArgs, sampleCreatives);

        expect(emittedValues.length, 3);
        expect(emittedValues[2], [
          sampleAds[0].copyWith(
            creative: sampleVideoCreatives[0].copyWith(
              filePath: 'mock/file.mp4',
            ),
          ),
        ]);
      });
    });

    test('update ad', () {
      when(mockAdApiClient.getAds(null)).thenAnswer(
        (_) => Future<List<Ad>>.value([
          sampleAds[0],
        ]),
      );

      when(mockAdApiClient.getAds(LatLng(53.817198, -2.417717))).thenAnswer(
        (_) => Future<List<Ad>>.value([
          sampleAds[0].copyWith(timeBlocks: 2, version: 1),
        ]),
      );

      fakeAsync((async) {
        adRepository.start();
        async.elapse(aSecond);

        expect(
          mockCreativeDownloader.downloadCalledArgs,
          [sampleCreatives[0]],
        );
        expect(emittedValues, [[]]);
        expect(errors, []);

        mockCreativeDownloader.downloadSuccess(sampleCreatives[0]);
        async.elapse(aSecond);

        expect(emittedValues.length, 2);
        expect(emittedValues[1], [
          sampleAds[0].copyWith(
            creative: sampleVideoCreatives[0].copyWith(
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
        mockCreativeDownloader.downloadSuccess(sampleCreatives[0]);
        async.elapse(aSecond);

        expect(
          mockCreativeDownloader.downloadCalledArgs,
          [
            sampleCreatives[0],
            sampleCreatives[0],
          ],
        );
        expect(emittedValues.length, 4);
        expect(emittedValues[3], [
          sampleAds[0].copyWith(
            timeBlocks: 2,
            creative: sampleVideoCreatives[0].copyWith(
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
