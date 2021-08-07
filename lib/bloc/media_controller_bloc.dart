
import 'package:rxdart/rxdart.dart';
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/controllers/image_slideshow_controller.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:video_player/video_player.dart';

class MediaControllerBloc {
  MediaBloc _bloc;
  MediaBloc get bloc => _bloc;

  // TODO Replace all the calls to bloc.bloc.type with type.
  // TODO Refactor the _bloc.type to a non-nullable type.
  Type get type => _bloc.type!;

  ImagerSlideshowController? _slideshowController;
  Object? _audioController;
  VideoPlayerController? _videoController;

  dynamic get controller =>
      _bloc.type == Type.VIDEO ? _videoController! : _audioController!;

  late Future<void> initializeControllerFuture;

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
      ? (_videoController == null ? true : _videoController!.value.isPlaying)
      : _audioController == null;
  
  // final _isPlayingSink = BehaviorSubject<bool>();
  // Stream<bool> get isPlayingStream => _isPlayingSink.stream;
  // void _isPlayingListener() => _isPlayingSink.sink.add(_videoController!.value.isPlaying);

  Duration get duration => Duration(
      milliseconds: int.parse(_bloc.currentMedia!.data.metadata['duration']!));

  double get durationSeconds => duration.inSeconds.toDouble();

  double get currentTimePosition => _bloc.type == Type.VIDEO
      ? _videoController!.value.position.inSeconds.toDouble()
      : 0.0; // TODO Implement audio player.

  final _currentTimePositionSink = PublishSubject<double>();
  Stream<double> get currentTimePositionStream =>
      _currentTimePositionSink.stream;

  void _currentTimeListener() => _currentTimePositionSink.sink.add(currentTimePosition);

  void seekTo(int position) {
    if(_bloc.type == Type.VIDEO) {

      _videoController?.seekTo(Duration(seconds: position));
    } else if(_bloc.type == Type.AUDIO) {
      // TODO Implement audio player.
    }
  }

  double get playSpeed => _bloc.type == Type.VIDEO
      ? controller.value.playbackSpeed
      : 1.0;  // TODO Implement audio player.

  set speed(double speed) {
    if(_bloc.type == Type.VIDEO) {
      _videoController!.setPlaybackSpeed(speed);
    } else if(_bloc.type == Type.AUDIO) {
      // TODO Implement audio player.
    }
  }

  bool get isLooping => _bloc.type == Type.VIDEO
      ? _videoController!.value.isLooping
      : false;  // TODO Implement audio player.

  set looper(bool loop) {
    if(_bloc.type == Type.VIDEO) {
      _videoController!.setLooping(loop);
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
      if (!_videoController!.value.isPlaying) {
        _videoController!.play();
      }
      _videoController!.addListener(_currentTimeListener);
      // _videoController!.addListener(_isPlayingListener);
    });
  }
  
  
  
  void dispose() {
    _videoController?.removeListener(_currentTimeListener);
    _currentTimePositionSink.close();
    // _isPlayingSink.close();
    // _isPlayingSink.close();
    // _slideshowController?.dispose();
    _videoController?.dispose();
    // _audioController?.dispose();
  }

}
