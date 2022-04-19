package com.stephenmorgandevelopment.super_media_bros_3.models

import android.net.Uri
import androidx.media2.common.SessionPlayer


enum class SuperMediaPlayerState(val value: Int) {
    PLAYER_STATE_IDLE(0),
    PLAYER_STATE_PAUSED(1),
    PLAYER_STATE_PLAYING(2),
    PLAYER_STATE_ERROR(3),

    BUFFERING_STATE_UNKNOWN(4),
    BUFFERING_STATE_BUFFERING_AND_PLAYABLE(5),
    BUFFERING_STATE_BUFFERING_AND_STARVED(6),
    BUFFERING_STATE_COMPLETE(7)
}    

class AudioPlayerState(
        val mediaUri: Uri,
        val initialState: SuperMediaPlayerState = SuperMediaPlayerState.PLAYER_STATE_IDLE
) {
    var state: SuperMediaPlayerState
        private set

    var position: Long = 0
        private set

    var isPlaying: Boolean = false
        private set

    var isReady: Boolean = false
        private set

    var isPreparing: Boolean = false
        private set

    var isError: Boolean = false
        private set

    var isBuffering: Boolean = false
        private set

    var isBufferStarved: Boolean = false
        private set

    init {
        state = initialState
    }

    val bufferState get(): Int {
        if(!isBuffering) {
            return -1
        }

        when {
            isBuffering && isReady -> SessionPlayer.BUFFERING_STATE_BUFFERING_AND_PLAYABLE
            isBufferStarved -> SessionPlayer.BUFFERING_STATE_BUFFERING_AND_STARVED
        }

        return SessionPlayer.BUFFERING_STATE_UNKNOWN
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