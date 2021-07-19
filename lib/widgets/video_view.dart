import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';
import 'package:super_media_bros_3/widgets/details_widget.dart';
import 'package:super_media_bros_3/widgets/media_view.dart';
import 'package:super_media_bros_3/widgets/controls/video_controls.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';
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
  VideoControls? controls;
  late MediaControllerBloc _bloc;

  bool isLeftFling = false;
  bool controlsShowing = false;
  bool speedSelectorShowing = false;

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
                  fit: StackFit.expand,
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
                    VideoControls(onPressed),
                    // speedSelectorShowing
                    //     ? ControlGroup(<Widget>[SpeedSelectSlider()],
                    //         Position(bottom: 220.0, right: 20.0, left: 20.0))
                    //     : Text(""),
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

  // List<Widget> buildTree() {
  //   List<Widget> widgetTree =
  //       List.from(<Widget>[videoPlayerWidget], growable: true);
  //
  //   if (controlsShowing) {
  //     if (controls == null) {
  //       controls = VideoControls(onPressed);
  //     }
  //
  //     widgetTree.add(Expanded(child: controls!));
  //   }
  //
  //   if (speedSelectorShowing) {
  //     Position curPos = Position(bottom: 220.0, right: 20.0, left: 20.0);
  //     widgetTree.add(ControlGroup(<Widget>[SpeedSelectSlider()], curPos));
  //   }
  //
  //   return widgetTree;
  // }

  dynamic get videoPlayerWidget => GestureDetector(
        onTap: () => toggleControls(),
        onPanEnd: (details) => processPan(details),
        onPanUpdate: (details) => {isLeftFling = (details.delta.dx < 0)},
        child: Center(
          child: AspectRatio(
            aspectRatio: _bloc.controller.value.aspectRatio,
            child: VideoPlayer(_bloc.controller),
          ),
        ),
      );

  void processPan(dynamic details) async {
    if (controlsShowing) {
      return;
    }

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
        speedSelectorShowing = !speedSelectorShowing;
        initState();
        break;
    }
  }
}
