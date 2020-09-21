import 'dart:developer' as dartDev;

import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';

import 'src/service/ad_api_client.dart';
import 'src/service/creative_downloader.dart';
import 'src/service/debugger.dart';
import 'src/service/file_downloader.dart';
import 'src/service/permission_controller.dart';
import 'src/service/power_provider.dart';
import 'src/widget/ad_view.dart';
import 'src/widget/debugger.dart';
import 'src/widget/permission_container.dart';
import 'src/widget/power_container.dart';

void main() {
  /// log to console
  Log.log$.listen(dartDev.log);

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<DebuggerFactory>(
      create: (_) {
        return DebuggerFactory()
          ..enablePermissionDebugger(true)
          ..enablePowerDebugger(true);
      },
      child: MaterialApp(
        routes: {
          '/debugger': (_) => Debugger(),
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
        child: Stack(
          children: [
            AdContainer(),
            PermissionContainer(),
            PowerContainer(),
          ],
        ),
      ),
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
          return MultiBlocProvider(
            providers: [
              BlocProvider<AppBloc>(
                create: (BuildContext context) {
                  return AppBloc(
                    AppState.init(),
                    adApiClient: adApiClient,
                    creativeDownloader: creativeDownloader,
                  )
                    ..add(const Permitted(true))
                    ..add(const PowerChanged(true));
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
