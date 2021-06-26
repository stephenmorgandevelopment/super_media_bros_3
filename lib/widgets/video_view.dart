
import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/models/media_resource.dart';
import 'package:super_media_bros_3/widgets/media_controls.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  static final String VIDEO_VIEW = 'video_view';
  final MediaBloc bloc;

  VideoView(this.bloc);
  VideoView.asPagedRoute() : this(MediaBloc.empty());

  @override
  State createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  bool isLeftFling = false;
  bool controlsShowing = false;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.file(widget.bloc.currentMedia!.file!);

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
                MediaControls(widget.bloc.currentMedia!.data, _controller),
              ],
            );
          } else {
            return Stack(children: [
              SafeArea(
                child: GestureDetector(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  onTap: () => toggleControls(),
                    onPanEnd: (details) => processPan(details),
                    onPanUpdate: (details) => {
                      isLeftFling = (details.delta.dx < 0)},
                ),
              )
            ]);
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void processPan(dynamic details) async {
    late MediaResource media;

    if (isLeftFling) {
      media = await widget.bloc.getNextMedia()!;
    } else {
      media = await widget.bloc.getPreviousMedia()!;
    }
    changeMediaTo(media);
  }

  void changeMediaTo(MediaResource media) async {
    await _controller.pause();
    // this.dispose();

    MaterialPageRoute videoRoute = MaterialPageRoute(
        builder: (context) => VideoView(widget.bloc));

    Navigator.pushReplacement(context, videoRoute);
  }

  void toggleControls() {
    controlsShowing = !controlsShowing;
    setState(() {});
  }
}
