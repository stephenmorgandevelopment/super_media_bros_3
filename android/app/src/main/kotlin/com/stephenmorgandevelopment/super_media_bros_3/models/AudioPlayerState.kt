package com.stephenmorgandevelopment.super_media_bros_3.models

import android.net.Uri


enum class SuperMediaState(val value: Int) {
    PLAYER_STATE_IDLE(0),
    PLAYER_STATE_PAUSED(1),
    PLAYER_STATE_PLAYING(2),
    PLAYER_STATE_ERROR(3),

    BUFFERING_STATE_UNKNOWN(4),
    BUFFERING_STATE_BUFFERING_AND_PLAYABLE(5),
    BUFFERING_STATE_BUFFERING_AND_STARVED(6),
    BUFFERING_STATE_COMPLETE(7)
}    

class AudioPlayerState(val mediaUri: Uri) {
    val state: SuperMediaState = SuperMediaState.PLAYER_STATE_IDLE
    val position: Long = 0
    val isPlaying: Boolean = false
    val isReady: Boolean = false
    val isPreparing: Boolean = false
    val isError: Boolean = false
    val isBuffering: Boolean = false

    fun getBuffState() : Int {
        if(!isBuffering) {
            return 0
        }

        return state.value - 4
    }

//    fun sameMediaAsObject(other: Any?): Boolean {
//        if(other is String) {
//            return sameMediaAsUri(other)
//        }
//        return ((other is AudioPlayerState) && (this.mediaUri == other.mediaUri))
//    }

//    fun isSameAsMediaItem(item: MediaItem?): Boolean {
//        return this.mediaUri ==
//                Uri.parse(item?.metadata?.getString(MediaMetadata.METADATA_KEY_MEDIA_URI)!!)
//                ?: false
//    }
}