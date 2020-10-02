import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeView extends StatefulWidget {
  final AdViewModel model;

  const YoutubeView({Key key, @required this.model}) : super(key: key);

  @override
  _YoutubeViewState createState() => _YoutubeViewState();
}

class _YoutubeViewState extends State<YoutubeView> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: 'aUZ9SbYsNxg',
      flags: YoutubePlayerFlags(
        hideControls: true,
        hideThumbnail: true,
        disableDragSeek: true,
        enableCaption: false,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: _controller),
      builder: (context, player) {
        return Column(
          children: [player],
        );
      },
    );
  }
}
