import 'package:rxdart/rxdart.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';

// TODO Make decision on whether to push functionality of controller buttons
// TODO down into subclasses, or leave it all as one super block for
// TODO the entire controller.
class CustomSliderBloc {
  // MediaControllerBloc _bloc;
  dynamic controller;

  CustomSliderBloc(MediaControllerBloc bloc)
      : this.controller = bloc.controller;

  BehaviorSubject<double> currentTimePositionSubject =
      BehaviorSubject<double>();

  Stream<double> get currentTimePositionStream =>
      currentTimePositionSubject.stream;

  // double get durationSeconds => controller.value;

  void dispose() {
    currentTimePositionSubject.close();
  }
}
