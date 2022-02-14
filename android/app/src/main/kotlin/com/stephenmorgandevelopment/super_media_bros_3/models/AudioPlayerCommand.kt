package com.stephenmorgandevelopment.super_media_bros_3.models

enum class SuperMediaCommand(val value: Int) {
    // Player / Playlist Commands
    PLAYER_PLAY(10000),
    PLAYER_PAUSE(10001),
    PLAYER_PREPARE (10002),
    PLAYER_SEEK_TO ( 10003),
    PLAYER_SET_SPEED ( 10004),
    PLAYER_GET_PLAYLIST ( 10005),
    PLAYER_SET_PLAYLIST ( 10006),
    PLAYER_SKIP_TO_PLAYLIST_ITEM ( 10007),
    PLAYER_SKIP_TO_PREVIOUS_PLAYLIST_ITEM ( 10008),
    PLAYER_SKIP_TO_NEXT_PLAYLIST_ITEM ( 10009),
    PLAYER_SET_SHUFFLE_MODE ( 10010),
    PLAYER_SET_REPEAT_MODE ( 10011),
    PLAYER_GET_PLAYLIST_METADATA ( 10012),
    PLAYER_ADD_PLAYLIST_ITEM ( 10013),
    PLAYER_REMOVE_PLAYLIST_ITEM ( 10014),
    PLAYER_REPLACE_PLAYLIST_ITEM ( 10015),
    PLAYER_GET_CURRENT_MEDIA_ITEM ( 10016),
    PLAYER_UPDATE_LIST_METADATA ( 10017),
    PLAYER_SET_MEDIA_ITEM ( 10018),
    PLAYER_MOVE_PLAYLIST_ITEM ( 10019),
    PLAYER_SET_SURFACE ( 11000),
    PLAYER_SELECT_TRACK ( 11001),
    PLAYER_DESELECT_TRACK ( 11002),

    // Volume Commands
    PLAYER_SET_VOLUME ( 30000),
    PLAYER_ADJUST_VOLUME ( 30000),

    // Session Commands
    PLAYER_SKIP_FORWARD ( 40002),
    PLAYER_SKIP_BACKWARD ( 40003),
    PLAYER_FAST_FORWARD ( 40000),
    PLAYER_REWIND ( 40001),
    PLAYER_SET_RATING ( 40010),
    PLAYER_SET_MEDIA_URI ( 40011),
}

class AudioPlayerCommand(val command: SuperMediaCommand)