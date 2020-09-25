import 'dart:developer' as dartDev;

import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';
import 'package:ad_bloc/model.dart';
import 'package:ad_bloc/src/service/camera_controller.dart';
import 'package:ad_bloc/src/service/gps/gps_adapter.dart';
import 'package:ad_bloc/src/service/movement_detector.dart';
import 'package:ad_bloc/src/widget/permission_container.dart';
import 'package:geolocator/geolocator.dart';

import 'config.dart';
import 'src/service/ad_repository/ad_api_client.dart';
import 'src/service/ad_repository/ad_repository.dart';
import 'src/service/ad_repository/creative_downloader.dart';
import 'src/service/age_detector.dart';
import 'src/service/debugger_factory.dart';
import 'src/service/face_detector.dart';
import 'src/service/file_downloader.dart';
import 'src/service/gender_detector.dart';
import 'src/service/gps/gps_controller.dart';
import 'src/service/permission_controller.dart';
import 'src/service/power_provider.dart';
import 'src/widget/ad_view.dart';
import 'src/widget/debug_button.dart';
import 'src/widget/debug_dashboard/debug_dashboard.dart';

void main() {
  // log Bloc events
  Bloc.observer = SimpleBlocObserver();

  // log to console
  Log.log$.listen(dartDev.log);

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<DebuggerFactory>(
      create: (_) => DebuggerFactoryImpl(),
      child: MaterialApp(
        routes: {
          '/debug': (_) => DebugDashboard(),
          '/': (_) => DIContainer(child: PermissionContainer(child: _App())),
        },
      ),
    );
  }
}

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AdContainer(),
      ),
      floatingActionButton: const DebugButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class DIContainer extends StatelessWidget {
  const DIContainer({Key key, @required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ConfigProvider>(
          create: (_) => ConfigProviderImpl()
            ..config = Config(
              timeBlockToSecs: 2,
              defaultAd: kDefaultAd,
              gpsAccuracy: 4,
              creativeBaseUrl: 'http://localhost:8080/public/creatives/',
              defaultAdRepositoryRefreshInterval: 15,
            ),
        ),
        Provider<AdApiClient>(create: (_) => FakeAdApiClient()),
        Provider<CreativeDownloader>(create: (_) {
          final mockFileDownloader = FakeFileDownloader();
          final image = ImageCreativeDownloader(mockFileDownloader);
          final video = VideoCreativeDownloader(mockFileDownloader);
          final html = HtmlCreativeDownloader(mockFileDownloader);
          final youtube = YoutubeCreativeDownloader();
          return ChainDownloaderImpl([image, video, html, youtube]);
        }),
        ProxyProvider4<AdApiClient, CreativeDownloader, ConfigProvider,
            DebuggerFactory, AdRepository>(
          update: (
            _,
            adApiClient,
            creativeDownloader,
            configProvider,
            debuggerFactory,
            __,
          ) {
            return AdRepositoryImpl(
              adApiClient,
              creativeDownloader,
              configProvider,
              debugger: debuggerFactory.adRepositoryDebugger,
            );
          },
        ),
        ProxyProvider<DebuggerFactory, GpsController>(
          update: (_, debuggerFactory, __) {
            return GpsControllerImpl(
              AdapterForGeolocator(Geolocator()),
              debugger: debuggerFactory.gpsDebugger,
            );
          },
        ),
        ProxyProvider<DebuggerFactory, PermissionController>(
          update: (_, debuggerFactory, __) {
            return PermissionControllerImpl(
              debugger: debuggerFactory.permissionDebugger,
            );
          },
        ),
        ProxyProvider<DebuggerFactory, PowerProvider>(
          update: (_, debuggerFactory, __) {
            return PowerProviderImpl(
              debugger: debuggerFactory.powerDebugger,
            );
          },
        ),
        ProxyProvider<DebuggerFactory, CameraController>(
          update: (_, debuggerFactory, __) {
            return CameraControllerImpl(
              debugger: debuggerFactory.cameraDebugger,
            );
          },
        ),
        ProxyProvider<GpsController, MovementDetector>(
          update: (_, gpsController, __) {
            return MovementDetectorImpl(gpsController.latLng$);
          },
        ),
        Provider<FaceDetector>(create: (_) => FaceDetectorImpl()),
        Provider<GenderDetector>(create: (_) => GenderDetectorImpl()),
        Provider<AgeDetector>(create: (_) => AgeDetectorImpl()),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final adConfig = Provider.of<ConfigProvider>(context).adConfig;
          final permissionController =
              Provider.of<PermissionController>(context);
          final powerProvider = Provider.of<PowerProvider>(context);
          final adRepository = Provider.of<AdRepository>(context);
          final gpsController = Provider.of<GpsController>(context);
          final movementDetector = Provider.of<MovementDetector>(context);
          final cameraController = Provider.of<CameraController>(context);
          final faceDetector = Provider.of<FaceDetector>(context);
          final genderDetector = Provider.of<GenderDetector>(context);
          final ageDetector = Provider.of<AgeDetector>(context);

          return MultiBlocProvider(
            providers: [
              BlocProvider<AppBloc>(
                create: (BuildContext context) {
                  return AppBloc(
                    AppState.init(),
                    permissionController: permissionController,
                    powerProvider: powerProvider,
                    adRepository: adRepository,
                    gpsController: gpsController,
                    movementDetector: movementDetector,
                    cameraController: cameraController,
                    faceDetector: faceDetector,
                    genderDetector: genderDetector,
                    ageDetector: ageDetector,
                  )..add(const Initialized());
                },
              ),
              BlocProvider<AdBloc>(
                create: (BuildContext context) => AdBloc(
                  AdState(),
                  appBloc: AppBloc.of(context),
                  adConfig: adConfig,
                ),
              ),
            ],
            child: child,
          );
        },
      ),
    );
  }
}
