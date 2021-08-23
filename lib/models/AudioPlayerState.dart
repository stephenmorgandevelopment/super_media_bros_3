
enum SuperMediaState {
  PLAYER_STATE_IDLE,
  PLAYER_STATE_PAUSED,
  PLAYER_STATE_PLAYING,
  PLAYER_STATE_ERROR,

  BUFFERING_STATE_UNKNOWN,
  BUFFERING_STATE_BUFFERING_AND_PLAYABLE,
  BUFFERING_STATE_BUFFERING_AND_STARVED,
  BUFFERING_STATE_COMPLETE
}

class AudioPlayerState {
  Uri mediaUri;
  AudioPlayerState(this.mediaUri);

  double position = 0;
  bool isPlaying = false;
  bool isReady = false;
  bool isPreparing = false;
  bool isError = false;
  bool isBuffering = false;

}