import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';
import 'package:super_media_bros_3/widgets/details_widget.dart';
import 'package:super_media_bros_3/widgets/media_view.dart';
import 'package:super_media_bros_3/widgets/controls/video_controls.dart';
import 'package:super_media_bros_3/widgets/super_media_buttons.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget with MediaView {
  static const String VIDEO_VIEW = 'video_view';

  // final MediaBloc _bloc;

  // bool get isPlaying => controlBloc.isPlaying;

  VideoView();

  // VideoView.asPagedRoute() : this(MediaBloc.empty());

  @override
  State createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  bool isLeftFling = false;
  bool controlsShowing = false;

  late MediaControllerBloc _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloc = MediaControllerBlocProvider.of(context);
    log("didChangeDependencies was called.");
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _bloc.initializeControllerFuture,
      builder: (BuildContext innerContext, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (controlsShowing) {
            return SafeArea(
              child: Scaffold(
                body: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: GestureDetector(
                        child: AspectRatio(
                          aspectRatio: _bloc.controller.value.aspectRatio,
                          child: VideoPlayer(_bloc.controller),
                        ),
                        onTap: () => toggleControls(),
                      ),
                    ),
                    Center(child: VideoControls(onPressed)),
                  ],
                ),
              ),
            );
          } else {
            return SafeArea(
              child: Scaffold(
                body: Center(
                  child: GestureDetector(
                    child: AspectRatio(
                      aspectRatio: _bloc.controller.value.aspectRatio,
                      child: VideoPlayer(_bloc.controller),
                    ),
                    onTap: () => toggleControls(),
                    onPanEnd: (details) => processPan(details),
                    onPanUpdate: (details) =>
                        {isLeftFling = (details.delta.dx < 0)},
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
    if (isLeftFling) {
      await _bloc.bloc.getNextMedia();
    } else {
      await _bloc.bloc.getPreviousMedia();
    }
    changeMedia();
  }

  void changeMedia() async {
    await _bloc.controller.pause();

    MaterialPageRoute videoRoute = MaterialPageRoute(
      builder: (context) =>
          MediaControllerBlocProvider(_bloc.bloc, child: VideoView()),
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
    dynamic dummy = _bloc;

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
        // TODO Make and display speed slider/selector.
        break;
    }
  }
}
