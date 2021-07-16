import 'dart:ffi';

import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/controllers/image_slideshow_controller.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:video_player/video_player.dart';

class MediaControllerBloc {
  MediaBloc _bloc;
  MediaBloc get bloc => _bloc;

  ImagerSlideshowController? _slideshowController;
  Object? _audioController;
  VideoPlayerController? _videoController;

  dynamic get controller =>
      _bloc.type == Type.VIDEO ? _videoController! : _audioController!;

  late Future<void> initializeControllerFuture;

  // MediaControllerBloc(this._bloc);
  MediaControllerBloc(this._bloc) {
    initController();
  }

  void initController() {
    if (_bloc.type == Type.VIDEO) {
      initAsVideo();
    } else if (_bloc.type == Type.AUDIO) {
      // TODO initialize audio controller.
    } else if (_bloc.type == Type.IMAGE){
      _slideshowController = ImagerSlideshowController();
    }
  }

  bool get isPlaying => _bloc.type == Type.VIDEO
      ? _videoController!.value.isPlaying
      : _audioController == null;

  Duration get duration => Duration(
      milliseconds: int.parse(_bloc.currentMedia!.data.metadata['duration']!));

  double get durationSeconds =>
      int.parse(_bloc.currentMedia!.data.metadata['duration']!) / 1000;

  double get currentPosition => _bloc.type == Type.VIDEO
      ? controller.value.position.inSeconds.toDouble()
      : 0.0; // TODO Implement audio player.

  void seekTo(int position) {
    if(_bloc.type == Type.VIDEO) {
      controller.seekTo(Duration(seconds: position));
    } else if(_bloc.type == Type.AUDIO) {
      // TODO Implement audio player.
    }
  }

  void initAsVideo() {
    _videoController = _bloc.currentMedia!.data.isLocal()
        ? VideoPlayerController.file(_bloc.currentMedia!.file!)
        : VideoPlayerController.network(
        _bloc.currentMedia!.data.uri.toString());

    initializeControllerFuture = _videoController!.initialize();

    initializeControllerFuture.whenComplete(() {
      if (!controller.value.isPlaying) {
        controller.play();
      }
    });
  }
  
  void dispose() {
    // _slideshowController?.dispose();
    _videoController?.dispose();
    // _audioController?.dispose();
  }

}
