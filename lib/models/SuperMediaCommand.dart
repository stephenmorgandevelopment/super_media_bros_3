
// TODO Map these to @IntDef equivalent or find a enum workaround.
// Darts enums are only index from 0++, so they are not able to
// hold the same values of the corresponding Java/Kotlin enums.
// This is going to cause some verbosity somewhere without a workaround.
class SuperMediaCommand {
  // TODO Temp workaround.
  int command;
  SuperMediaCommand(this.command);

  static const int PLAYER_PLAY = 10000;
  static const int PLAYER_PAUSE = 10001;
  static const int PLAYER_PREPARE = 10002;
  static const int PLAYER_SEEK_TO = 10003;
  static const int PLAYER_SET_SPEED = 10004;
  static const int PLAYER_GET_PLAYLIST = 10005;
  static const int PLAYER_SET_PLAYLIST = 10006;
  static const int PLAYER_SKIP_TO_PLAYLIST_ITEM = 10007;
  static const int PLAYER_SKIP_TO_PREVIOUS_PLAYLIST_ITEM = 10008;
  static const int PLAYER_SKIP_TO_NEXT_PLAYLIST_ITEM = 10009;
  static const int PLAYER_SET_SHUFFLE_MODE = 10010;
  static const int PLAYER_SET_REPEAT_MODE = 10011;
  static const int PLAYER_GET_PLAYLIST_METADATA = 10012;
  static const int PLAYER_ADD_PLAYLIST_ITEM = 10013;
  static const int PLAYER_REMOVE_PLAYLIST_ITEM = 10014;
  static const int PLAYER_REPLACE_PLAYLIST_ITEM = 10015;
  static const int PLAYER_GET_CURRENT_MEDIA_ITEM = 10016;
  static const int PLAYER_UPDATE_LIST_METADATA = 10017;
  static const int PLAYER_SET_MEDIA_ITEM = 10018;
  static const int PLAYER_MOVE_PLAYLIST_ITEM = 10019;
  static const int PLAYER_SET_SURFACE = 11000;
  static const int PLAYER_SELECT_TRACK = 11001;
  static const int PLAYER_DESELECT_TRACK = 11002;
  static const int PLAYER_SET_VOLUME = 30000;
  static const int PLAYER_ADJUST_VOLUME = 30001;
  static const int PLAYER_FAST_FORWARD = 40000;
  static const int PLAYER_REWIND = 40001;
  static const int PLAYER_SKIP_FORWARD = 40002;
  static const int PLAYER_SKIP_BACKWARD = 40003;
  static const int PLAYER_SET_RATING = 40010;
  static const int PLAYER_SET_MEDIA_URI = 40011;
}