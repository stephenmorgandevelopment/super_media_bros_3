

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/widgets/controls/control_group.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';

class MediaControllerEditBloc implements MediaControllerBloc {
  late MediaBloc bloc;
  late Future<void> initializeControllerFuture;

  List<String> controlGroupsJson = List.empty(growable: true);
  List<ControlGroup> controlGroups = List.empty(growable: true);

  String currentButtonEditingTag = 'null';
  SuperMediaButton? currentButtonEditing;
  Key? currentGroupEditing;

  MediaControllerEditBloc(this.bloc) {
    initializeControllerFuture = initController();
  }

  // final _isPlayingSink = BehaviorSubject<bool>();
  // Stream<bool> get isPlayingStream => _isPlayingSink.stream;
  // void _isPlayingListener() => _isPlayingSink.sink.add(isPlaying);

  bool get isPlaying => true;
  Duration get duration => Duration(seconds: 105);
  double get durationSeconds => duration.inSeconds.toDouble();
  double get currentPosition => Duration(seconds: 47).inSeconds.toDouble();
  double get playSpeed => 1.0;
  bool get isLooping => false;

  void seekTo(int time) {

  }

  Future<void> initController() async {

  }

  void dispose() {

  }

  void initAsVideo() {

  }

  @override
  // TODO: implement controller
  get controller => throw UnimplementedError();

  @override
  // TODO: implement currentPositionStream
  Stream<double> get currentPositionStream => BehaviorSubject.seeded(currentPosition);

  @override
  set looper(bool loop) {
    // TODO: implement looper
  }

  @override
  set speed(double speed) {
    // TODO: implement speed
  }

}