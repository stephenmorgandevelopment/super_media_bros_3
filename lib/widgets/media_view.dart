

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
import 'package:super_media_bros_3/mediaplayer/media_controls_config.dart';
import 'package:super_media_bros_3/mediaplayer/media_gesture_detector.dart';
import 'package:super_media_bros_3/mediaplayer/media_player_config.dart';

abstract class MediaView extends StatefulWidget {
  // final Fling _fling = Fling();
  late final MediaControllerBloc _bloc;

  // bool get isPlaying;
  // void onPressed(String tag);


}

abstract class MediaViewState<T extends MediaView> extends State<T> {
  @protected
  final Fling fling = Fling();

  @protected
  late final MediaControllerBloc bloc;

  @override
  void initState() {
    MediaControlsConfig.init();
    super.initState();
  }
}

class Fling {
  Direction? direction;

  void update(dynamic details) {
    // bool left = (details.delta.dx < 0);
    // bool down = (details.delta.dy < 0);
    // bool horizontal = (details.delta.dx.abs() > details.delta.dy.abs());
    //
    // direction = horizontal
    //     ? (left ? Direction.LEFT : Direction.RIGHT)
    //     : (down ? Direction.DOWN : Direction.UP);

    direction = (details.delta.dx.abs() > details.delta.dy.abs())
        ? (details.delta.dx < 0 ? Direction.LEFT : Direction.RIGHT)
        : (details.delta.dy < 0 ? Direction.DOWN : Direction.UP);
  }
}

enum Direction {UP, DOWN, LEFT, RIGHT}