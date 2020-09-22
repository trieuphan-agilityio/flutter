import 'dart:developer' as dartDev;

import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';
import 'package:ad_bloc/src/service/gps/gps_adapter.dart';
import 'package:geolocator/geolocator.dart';

import 'src/service/ad_api_client.dart';
import 'src/service/creative_downloader.dart';
import 'src/service/debugger_factory.dart';
import 'src/service/file_downloader.dart';
import 'src/service/gps/gps_controller.dart';
import 'src/service/permission_controller.dart';
import 'src/service/power_provider.dart';
import 'src/widget/ad_view.dart';
import 'src/widget/debug_button.dart';
import 'src/widget/debug_dashboard.dart';

void main() {
  // log Bloc events
  //Bloc.observer = SimpleBlocObserver();

  // log to console
  Log.log$.listen(dartDev.log);

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<DebuggerFactory>(
      create: (_) {
        return DebuggerFactoryImpl()..driverOnboarded();
      },
      child: MaterialApp(
        routes: {
          '/debug': (_) => DebugDashboard(),
          '/': (_) => DIContainer(child: _App()),
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
        Provider<AdApiClient>(create: (_) => FakeAdApiClient()),
        Provider<CreativeDownloader>(create: (_) {
          final mockFileDownloader = FakeFileDownloader();
          final image = ImageCreativeDownloader(mockFileDownloader);
          final video = VideoCreativeDownloader(mockFileDownloader);
          final html = HtmlCreativeDownloader(mockFileDownloader);
          final youtube = YoutubeCreativeDownloader();
          return ChainDownloaderImpl([image, video, html, youtube]);
        }),
        Provider<GpsController>(create: (_) {
          return GpsControllerImpl(AdapterForGeolocator(Geolocator()));
        }),
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
      ],
      child: Builder(
        builder: (BuildContext context) {
          final adApiClient = Provider.of<AdApiClient>(context);
          final creativeDownloader = Provider.of<CreativeDownloader>(context);
          final gpsController = Provider.of<GpsController>(context);
          final permissionController =
              Provider.of<PermissionController>(context);
          final powerProvider = Provider.of<PowerProvider>(context);

          return MultiBlocProvider(
            providers: [
              BlocProvider<AppBloc>(
                create: (BuildContext context) {
                  return AppBloc(
                    AppState.init(),
                    permissionController: permissionController,
                    powerProvider: powerProvider,
                    adApiClient: adApiClient,
                    creativeDownloader: creativeDownloader,
                    gpsController: gpsController,
                  )..add(const Initialized());
                },
              ),
              BlocProvider<AdBloc>(
                create: (BuildContext context) => AdBloc(
                  AdState(),
                  appBloc: AppBloc.of(context),
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
