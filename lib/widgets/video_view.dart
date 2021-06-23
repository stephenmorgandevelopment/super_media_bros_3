import 'package:flutter/material.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/models/media_resource.dart';
import 'package:super_media_bros_3/widgets/media_controls.dart';
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
                MediaControls(widget.media.data, _controller),
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
