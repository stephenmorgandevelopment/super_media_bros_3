

import 'package:rxdart/rxdart.dart';
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
import 'package:super_media_bros_3/models/media_data.dart';

class MediaControllerEditBloc implements MediaControllerBloc {
  late MediaBloc bloc;
  late Future<void> initializeControllerFuture;

  String? json;

  MediaControllerEditBloc(this.bloc) {
    initializeControllerFuture = initController();
  }

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