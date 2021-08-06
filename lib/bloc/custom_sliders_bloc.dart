

import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';

class CustomSliderBloc {
  MediaControllerBloc _bloc;

  CustomSliderBloc(this._bloc);

  Stream<double> get currentTimePositionStream =>
      _bloc.currentTimePositionStream;

  double get durationSeconds => _bloc.durationSeconds;
}