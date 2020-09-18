import 'dart:developer' as dartDev;

import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';
import 'package:ad_bloc/src/service/ad_api_client.dart';
import 'package:ad_bloc/src/service/creative_downloader.dart';
import 'package:ad_bloc/src/service/file_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/ui/ad_view.dart';

void main() {
  /// log to console
  Log.log$.listen(dartDev.log);

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (_) {
            final mockFileDownloader = FakeFileDownloader();
            final image = ImageCreativeDownloader(mockFileDownloader);
            final video = VideoCreativeDownloader(mockFileDownloader);
            final html = HtmlCreativeDownloader(mockFileDownloader);
            final youtube = YoutubeCreativeDownloader();

            return AppBloc(
              AppState.init(),
              adApiClient: FakeAdApiClient(),
              creativeDownloader: ChainDownloaderImpl([
                image,
                video,
                html,
                youtube,
              ]),
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
      child: MaterialApp(
        home: Stack(
          children: [
            AdContainer(),
          ],
        ),
      ),
    );
  }
}
