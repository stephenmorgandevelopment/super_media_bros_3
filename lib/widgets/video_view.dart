import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/models/media_resource.dart';
import 'package:super_media_bros_3/widgets/media_view.dart';
import 'package:super_media_bros_3/widgets/video_controls.dart';
import 'package:super_media_bros_3/widgets/super_media_buttons.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget with MediaView {
  static const String VIDEO_VIEW = 'video_view';
  final MediaBloc _bloc;

  bool get isPlaying => _bloc.isPlaying;

  VideoView(this._bloc);

  VideoView.asPagedRoute() : this(MediaBloc.empty());

  @override
  State createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  bool isLeftFling = false;
  bool controlsShowing = false;

  late VideoPlayerController _controller;

  VideoPlayerController get controller => _controller;

  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.file(widget._bloc.currentMedia!.file!);

    _initializeVideoPlayerFuture = _controller.initialize();

    _initializeVideoPlayerFuture.whenComplete(() {
      _controller.addListener(updateBlocState);
      if (!_controller.value.isPlaying) {
        _controller.play();
      }
    });

    super.initState();
  }

  void updateBlocState() {
    widget._bloc.isPlaying = _controller.value.isPlaying;
  }

  @override
  void dispose() {
    _controller.removeListener(updateBlocState);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (BuildContext ctxt, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (controlsShowing) {
            return SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: GestureDetector(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      onTap: () => toggleControls(),
                    ),
                  ),
                  Center(
                      child:
                          VideoControls(SuperMediaButtons(context, onPressed))),
                ],
              ),
            );

            // return Stack(
            //   children: [
            //     SafeArea(
            //       child: GestureDetector(
            //         child: Center(
            //           child: AspectRatio(
            //             aspectRatio: _controller.value.aspectRatio,
            //             child: VideoPlayer(_controller),
            //           ),
            //         ),
            //         onTap: () => toggleControls(),
            //       ),
            //     ),
            //     VideoControls(_controller, onPressed),
            //   ],
            // );
          } else {
            return SafeArea(
              child: Center(
                child: GestureDetector(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  onTap: () => toggleControls(),
                  onPanEnd: (details) => processPan(details),
                  onPanUpdate: (details) =>
                      {isLeftFling = (details.delta.dx < 0)},
                ),
              ),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  TextStyle detailsTextStyle = TextStyle(
    color: Colors.white,
    backgroundColor: Colors.black38,
    fontSize: 18.0,
  );

  void onPressed(String btnTag) async {
    switch (btnTag) {
      case PLAY_TAG:
        if (_controller.value.isPlaying) {
          _controller.pause();
        } else {
          _controller.play();
        }
        setState(() {});
        break;
      case SEEK_FWD_TAG:
        int curPos = (await _controller.position)?.inMilliseconds ?? 0;
        Duration newPos =
            Duration(milliseconds: (curPos + MediaOptions.seekForwardTime));
        _controller.seekTo(newPos);
        break;
      case SEEK_BACK_TAG:
        int curPos = (await _controller.position)?.inMilliseconds ?? 0;
        Duration newPos =
            Duration(milliseconds: (curPos - MediaOptions.seekBackwardsTime));
        _controller.seekTo(newPos);
        break;
      case NEXT_TAG:
        await widget._bloc.getNextMedia();
        changeMedia();
        break;
      case PREV_TAG:
        await widget._bloc.getPreviousMedia();
        changeMedia();
        break;
      case DETAILS_TAG:
        List<Widget> dataTexts = List.empty(growable: true);

        Map<String, String> metadata = widget._bloc.currentMedia!.data.metadata;
        for (MapEntry entry in metadata.entries) {
          dataTexts.add(Text(
            "${entry.key}: ${entry.value}",
            style: detailsTextStyle,
          ));
        }

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SafeArea(
                      child: Column(
                        children: dataTexts,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    )));
        break;
      case "speed":
        // TODO Make and display speed slider/selector.
        break;
    }
  }

  void processPan(dynamic details) async {
    if (isLeftFling) {
      await widget._bloc.getNextMedia();
    } else {
      await widget._bloc.getPreviousMedia();
    }
    changeMedia();
  }

  void changeMedia() async {
    await _controller.pause();

    MaterialPageRoute videoRoute =
        MaterialPageRoute(builder: (context) => VideoView(widget._bloc));

    Navigator.pushReplacement(context, videoRoute);
  }

  void toggleControls() {
    log("toggleControls called.");
    controlsShowing = !controlsShowing;
    setState(() {
      log('setState - called.');
    });
  }
}
