import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';
import 'package:super_media_bros_3/widgets/details_widget.dart';
import 'package:super_media_bros_3/widgets/media_view.dart';
import 'package:super_media_bros_3/widgets/controls/video_controls.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';
import 'package:video_player/video_player.dart';

class VideoView extends MediaView {
  static const String VIDEO_VIEW = 'video_view';

  VideoView();

  @override
  State createState() => _VideoViewState();
}

class _VideoViewState extends MediaViewState<VideoView> {
  VideoControls? controls;

  bool isLeftFling = false;
  bool controlsShowing = false;
  bool speedSelectorShowing = false;

  @override
  void didChangeDependencies() {
    bloc = MediaControllerBlocProvider.of(context);
    log("didChangeDependencies was called.");

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: bloc.initializeControllerFuture,
      builder: (BuildContext innerContext, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (controlsShowing) {
            return SafeArea(
              child: Scaffold(
                body: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: GestureDetector(
                          child: AspectRatio(
                            aspectRatio: bloc.controller.value.aspectRatio,
                            child: VideoPlayer(bloc.controller),
                          ),
                          onTap: () => toggleControls(),
                        ),
                      ),
                      VideoControls(onPressed),
                    ]),
              ),
            );
          } else {
            return SafeArea(
              child: Scaffold(
                body: Center(
                  child: GestureDetector(
                    child: AspectRatio(
                      aspectRatio: bloc.controller.value.aspectRatio,
                      child: VideoPlayer(bloc.controller),
                    ),
                    onTap: () => toggleControls(),
                    onPanEnd: (details) => processPan(details),
                    onPanUpdate: fling.update,
                  ),
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

  void processPan(dynamic details) async {
    if (controlsShowing) {
      return;
    }

    switch (fling.direction) {
      case Direction.LEFT:
        await bloc.bloc.getNextMedia();
        break;
      case Direction.RIGHT:
        await bloc.bloc.getPreviousMedia();
        break;
      default:
        return;
    }

    changeMedia();
  }

  void changeMedia() async {
    await bloc.controller.pause();

    MaterialPageRoute videoRoute = MaterialPageRoute(
      builder: (context) =>
          MediaControllerBlocProvider(bloc.bloc, child: VideoView()),
    );

    Navigator.pushReplacement(context, videoRoute);
  }

  void toggleControls() {
    log("toggleControls called.");
    controlsShowing = !controlsShowing;
    setState(() {
      log('setState - called.');
    });
  }

  void triggerEvent() {
    setState(() => {});
  }

  void onPressed(String btnTag) async {
    dynamic dummy = bloc;

    switch (btnTag) {
      case PLAY_TAG:
        if (dummy.controller.value.isPlaying) {
          dummy.controller.pause();
        } else {
          dummy.controller.play();
        }
        setState(() {});
        break;
      case SEEK_FWD_TAG:
        int curPos = (await dummy.controller.position)?.inMilliseconds ?? 0;
        Duration newPos =
            Duration(milliseconds: (curPos + MediaOptions.seekForwardTime));
        dummy.controller.seekTo(newPos);
        break;
      case SEEK_BACK_TAG:
        int curPos = (await dummy.controller.position)?.inMilliseconds ?? 0;
        Duration newPos =
            Duration(milliseconds: (curPos - MediaOptions.seekBackwardsTime));
        dummy.controller.seekTo(newPos);
        break;
      case NEXT_TAG:
        await dummy.bloc.getNextMedia();
        changeMedia();
        break;
      case PREV_TAG:
        await dummy.bloc.getPreviousMedia();
        changeMedia();
        break;
      case DETAILS_TAG:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DetailsWidget(dummy.bloc.currentMedia!.data)));
        break;
      case SPEED_TAG:
        speedSelectorShowing = !speedSelectorShowing;
        setState(() {});
        break;
      default:
        toggleControls();
    }
  }
}
