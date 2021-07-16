
class ImagerSlideshowController {
  bool _isPlaying = true;
  bool get isPlaying => _isPlaying;

  void play() {
    _isPlaying = true;

  }

  void pause() {
    _isPlaying = false;

  }

}