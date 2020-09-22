import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';
import 'package:ad_bloc/model.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import '../utils.dart';

main() {
  AppBloc appBloc;
  List<AppEvent> emittedEvents;

  MockAdRepository adRepository;

  StreamController<LatLng> latLng$Controller;
  MockGpsController gpsController;

  StreamController<bool> isAllowed$Controller;
  MockPermissionController permissionController;

  StreamController<bool> isStrong$Controller;
  MockPowerProvider powerProvider;

  group('AppBloc', () {
    setUp(() {
      adRepository = MockAdRepository();

      latLng$Controller = StreamController.broadcast();
      gpsController = MockGpsController(latLng$Controller.stream);

      isAllowed$Controller = StreamController.broadcast();
      permissionController =
          MockPermissionController(isAllowed$Controller.stream);

      isStrong$Controller = StreamController.broadcast();
      powerProvider = MockPowerProvider(isStrong$Controller.stream);

      emittedEvents = [];

      appBloc = AppBloc(
        AppState.init(),
        adRepository: adRepository,
        gpsController: gpsController,
        permissionController: permissionController,
        powerProvider: powerProvider,
      );

      appBloc.event$.listen(emittedEvents.add);
    });

    tearDown(() {
      resetMockitoState();
      latLng$Controller.close();
      isAllowed$Controller.close();
      isStrong$Controller.close();
      appBloc.close();
    });

    _permit(bool isAllowed) {
      isAllowed$Controller.add(isAllowed);
    }

    _powerSupply(bool isStrong) {
      isStrong$Controller.add(isStrong);
    }

    _locate(LatLng latLng) {
      latLng$Controller.add(latLng);
    }

    _fetchAds(Iterable<Ad> ads) {
      adRepository.ads = ads;
    }

    test('stopped when permission is denied or power is weak', () async {
      appBloc.add(const Initialized());
      await flushMicrotasks();

      expect(permissionController.startCalled, 1);
      expect(powerProvider.startCalled, 1);

      _permit(false);
      _powerSupply(true);
      await flushMicrotasks();

      expect(emittedEvents, [
        const Initialized(),
        const Permitted(false),
        const PowerSupplied(true),
      ]);
      expect(
        appBloc.state,
        AppState.init().copyWith(
          isPermitted: false,
          isPowerStrong: true,
          isStarted: false,
        ),
      );

      _powerSupply(false);
      _permit(true);
      await flushMicrotasks();

      expect(emittedEvents.skip(3), [
        const PowerSupplied(false),
        const Permitted(true),
      ]);
      expect(
        appBloc.state,
        AppState.init().copyWith(
          isPermitted: true,
          isPowerStrong: false,
          isStarted: false,
        ),
      );
    });

    test('started', () async {
      appBloc.add(const Initialized());
      await flushMicrotasks();

      expect(permissionController.startCalled, 1);
      expect(powerProvider.startCalled, 1);

      _permit(true);
      _powerSupply(true);
      await flushMicrotasks();

      expect(emittedEvents, [
        const Initialized(),
        const Permitted(true),
        const PowerSupplied(true),
        const Started(),
      ]);
      expect(
        appBloc.state,
        AppState.init().copyWith(
          isPermitted: true,
          isPowerStrong: true,
          isStarted: true,
          isTrackingLocation: true,
        ),
      );
    });

    test('fetch new ads when location is changed', () async {
      // App started
      final initialState = AppState.init().copyWith(
        isPermitted: true,
        isPowerStrong: true,
      );
      appBloc.add(AppChangedState(initialState));
      appBloc.add(const Started());
      await flushMicrotasks();

      expect(gpsController.startCalled, 1);

      _locate(const LatLng(53.817198, -2.417717));
      await flushMicrotasks();

      expect(adRepository.changeLocationCalledArgs, [
        const LatLng(53.817198, -2.417717),
      ]);

      _fetchAds(sampleAds);
      await flushMicrotasks();

      expect(emittedEvents.skip(1), [
        const Started(),
        const Located(const LatLng(53.817198, -2.417717)),
        ReadyAdsChanged(sampleAds),
      ]);
      expect(
        appBloc.state,
        initialState.copyWith(
          isTrackingLocation: true,
          isFetchingAds: true,
          latLng: const LatLng(53.817198, -2.417717),
          newAds: [],
          readyAds: sampleAds,
        ),
      );
    });
  });
}
