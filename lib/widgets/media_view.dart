import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
import 'package:super_media_bros_3/mediaplayer/media_controls_config.dart';

abstract class MediaView extends StatefulWidget {}

abstract class MediaViewState<T extends MediaView> extends State<T> {
  @protected
  final Fling fling = Fling();

  @protected
  late MediaControllerBloc bloc;

  @override
  void initState() {
    MediaControlsConfig.init();
    super.initState();
  }
}

class Fling {
  Direction? direction;

  void update(dynamic details) {
    direction = (details.delta.dx.abs() > details.delta.dy.abs())
        ? (details.delta.dx < 0 ? Direction.LEFT : Direction.RIGHT)
        : (details.delta.dy < 0 ? Direction.DOWN : Direction.UP);
  }
}

enum Direction { UP, DOWN, LEFT, RIGHT }
