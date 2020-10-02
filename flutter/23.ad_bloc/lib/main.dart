import 'dart:developer' as dartDev;

import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';
import 'package:ad_bloc/model.dart';
import 'package:ad_bloc/src/service/camera_controller.dart';
import 'package:ad_bloc/src/service/gps/gps_adapter.dart';
import 'package:ad_bloc/src/service/movement_detector.dart';
import 'package:ad_bloc/src/widget/app_scaffold.dart';
import 'package:geolocator/geolocator.dart';

import 'config.dart';
import 'src/service/ad_repository/ad_api_client.dart';
import 'src/service/ad_repository/ad_repository.dart';
import 'src/service/ad_repository/creative_downloader.dart';
import 'src/service/age_detector.dart';
import 'src/service/debugger_builder.dart';
import 'src/service/face_detector.dart';
import 'src/service/file_downloader.dart';
import 'src/service/gender_detector.dart';
import 'src/service/gps/gps_controller.dart';
import 'src/service/permission_controller.dart';
import 'src/service/power_provider.dart';
import 'src/widget/ad_view/ad_view.dart';
import 'src/widget/debug_dashboard/debug_dashboard.dart';
import 'src/widget/bootstrap.dart';
import 'src/widget/permission_container.dart';

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
    return ChangeNotifierProvider<DebuggerBuilder>(
      create: (_) => DebuggerBuilder(),
      child: MaterialApp(routes: {
        '/': (_) => Bootstrap(nextRouteName: '/ad'),
        '/ad': (_) => DIContainer(child: PermissionContainer(child: _App())),
        '/debug': (_) => DebugDashboard(),
      }),
    );
  }
}

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // reload the Ad if and only if AdConfig is changed, regardless of any other
    // config properties are changed.
    final adConfig = context.select((ConfigProvider cp) => cp.adConfig);

    return AppScaffold(
      body: BlocProvider<AdBloc>(
        create: (_) => AdBloc(
          AdState(AdViewModel.fromAd(kScreensaverAd, adConfig)),
          appBloc: AppBloc.of(context),
          adConfig: adConfig,
        ),
        child: AdView(),
      ),
    );
  }
}

class DIContainer extends StatelessWidget {
  final Widget child;

  const DIContainer({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final debugger = Provider.of<DebuggerBuilder>(context).debugger;

    return MultiProvider(
      providers: [
        Provider<ConfigProvider>(
          create: (_) => ConfigProviderImpl(debugger: debugger.configDebugger),
        ),
        ProxyProvider<ConfigProvider, CreativeDownloader>(
          update: (_, configProvider, __) {
            final config = configProvider.downloaderConfig;
            final fileDownloader = FileDownloaderImpl(
              fileUrlResolver: FileUrlResolverImpl(),
              filePathResolver: FilePathResolverImpl(),
              options: DownloadOptions(
                numOfParallelTasks: config.creativeDownloadParallelTasks,
                timeoutSecs: config.creativeDownloadTimeout,
              ),
            );

            final videoDownloader = FileDownloaderImpl(
              fileUrlResolver: FileUrlResolverImpl(),
              filePathResolver: FilePathResolverImpl(),
              options: DownloadOptions(
                numOfParallelTasks: config.videoCreativeDownloadParallelTasks,
                timeoutSecs: config.videoCreativeDownloadTimeout,
              ),
            );

            final image = ImageCreativeDownloader(fileDownloader);
            final html = HtmlCreativeDownloader(fileDownloader);
            final video = VideoCreativeDownloader(videoDownloader);
            final youtube = YoutubeCreativeDownloader();

            return ChainDownloaderImpl([image, video, html, youtube]);
          },
        ),
        Provider<AdApiClient>(create: (_) {
          return FakeAdApiClient(debugger: debugger.adApiClientDebugger);
        }),
        ProxyProvider3<AdApiClient, CreativeDownloader, ConfigProvider,
            AdRepository>(
          update: (_, adApiClient, creativeDownloader, configProvider, __) {
            return AdRepositoryImpl(
              adApiClient,
              creativeDownloader,
              configProvider,
              configProvider,
            );
          },
        ),
        Provider<GpsController>(
          create: (_) => GpsControllerImpl(
            AdapterForGeolocator(Geolocator()),
            debugger: debugger.gpsDebugger,
          ),
        ),
        Provider<PermissionController>(
          create: (_) =>
              PermissionControllerImpl(debugger: debugger.permissionDebugger),
        ),
        Provider<PowerProvider>(
          create: (_) => PowerProviderImpl(debugger: debugger.powerDebugger),
        ),
        Provider<CameraController>(
          create: (_) =>
              CameraControllerImpl(debugger: debugger.cameraDebugger),
        ),
        ProxyProvider<GpsController, MovementDetector>(
          update: (_, gpsController, __) {
            return MovementDetectorImpl(gpsController.latLng$);
          },
        ),
        Provider<FaceDetector>(create: (_) => FakeFaceDetector()),
        Provider<GenderDetector>(create: (_) => FakeGenderDetector()),
        Provider<AgeDetector>(create: (_) => FakeAgeDetector()),
      ],
      child: Builder(
        builder: (BuildContext context) {
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

          return BlocProvider<AppBloc>(
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
            child: child,
          );
        },
      ),
    );
  }
}
