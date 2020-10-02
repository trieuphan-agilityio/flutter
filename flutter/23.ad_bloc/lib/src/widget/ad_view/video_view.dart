import 'dart:io';

import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final AdViewModel model;

  const VideoView({Key key, @required this.model}) : super(key: key);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.model.filePath))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized,
        // even before the play button has been pressed.
        setState(() {});
      }).then((_) => _controller.play());
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tightFor(
        width: double.infinity,
        height: double.infinity,
      ),
      child: _controller.value.initialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Container(),
    );
  }
}
