import 'package:flutter/material.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/models/media_resource.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final MediaResource media;

  VideoView(this.media);

  @override
  State createState() => _VideoViewState();
}

late VideoPlayerController _controller;

class _VideoViewState extends State<VideoView> {
  bool controlsShowing = false;

  // late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.file(widget.media.file!);

    _initializeVideoPlayerFuture = _controller.initialize();

    _initializeVideoPlayerFuture.whenComplete(() => {
          if (!_controller.value.isPlaying) {_controller.play()}
        });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (controlsShowing) {
            return Stack(
              children: [
                SafeArea(
                  child: GestureDetector(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    onTap: () => toggleControls(),
                  ),
                ),
                Container(
                  child: Material(
                    child: VideoControls(widget.media.data),
                    type: MaterialType.transparency,
                  ),
                  constraints: BoxConstraints.expand(),
                  alignment: Alignment.bottomCenter,
                ),
              ],
            );
          } else {
            return SafeArea(
              child: GestureDetector(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                onTap: () => toggleControls(),
              ),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void toggleControls() {
    controlsShowing = !controlsShowing;

    setState(() {});
  }
}

class VideoControls extends StatelessWidget {
  static final double iconsize = 40.0;
  final MediaData mediaData;

  VideoControls(this.mediaData);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: makeControls(),
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
    );
  }

  List<Widget> makeControls() {
    return <Widget>[
      IconButton(
          onPressed: () => onPressed("speed"),
          iconSize: iconsize,
          icon: Icon(
            Icons.slow_motion_video_outlined,
            color: Colors.white38,
            semanticLabel: "Adjust playback speed of the video.",
          )),
      IconButton(
          onPressed: () => onPressed("prev"),
          iconSize: iconsize,
          icon: Icon(
            Icons.skip_previous_outlined,
            color: Colors.white38,
            semanticLabel: "Previous video.",
          )),
      IconButton(
          onPressed: () => onPressed("seek-back"),
          iconSize: iconsize,
          icon: Icon(
            Icons.fast_rewind_outlined,
            color: Colors.white38,
            semanticLabel: "Seek backwards in the video.",
          )),
      IconButton(
          onPressed: () => onPressed("play-pause"),
          iconSize: iconsize,
          icon: Icon(
            _controller.value.isPlaying
                ? Icons.pause_circle_filled_outlined
                : Icons.play_circle_fill_outlined,
            color: Colors.white38,
            semanticLabel: "Play or pause the video.",
          )),
      IconButton(
          onPressed: () => onPressed("seek-fwd"),
          iconSize: iconsize,
          icon: Icon(
            Icons.fast_forward_outlined,
            color: Colors.white38,
            semanticLabel: "Seek forward in the video.",
          )),
      IconButton(
          onPressed: () => onPressed("next"),
          iconSize: iconsize,
          icon: Icon(
            Icons.skip_next_outlined,
            color: Colors.white38,
            semanticLabel: "Next video.",
          )),
      IconButton(
          onPressed: () => onPressed("details"),
          iconSize: iconsize,
          icon: Icon(
            Icons.info_outlined,
            color: Colors.white38,
            semanticLabel: "View details about the video.",
          )),
    ];
  }

  void onPressed(String button) async {
    switch (button) {
      case "play-pause":

        // Navigator.push(ctx, MaterialPageRoute(builder: (context) => text));
        break;
      case "seek-fwd":
        break;
      case "seek-back":
        break;
      case "next":
        break;
      case "prev":
        break;
      case "details":
        break;
      case "speed":
        break;
    }
  }
}
