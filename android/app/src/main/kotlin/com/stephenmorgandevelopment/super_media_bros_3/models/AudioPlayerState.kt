package com.stephenmorgandevelopment.super_media_bros_3.models

import android.media.browse.MediaBrowser
import android.net.Uri
import androidx.media2.common.MediaItem
import androidx.media2.common.MediaMetadata

class AudioPlayerState(val mediaUri: Uri) {
    val position: Long = 0
    val isPlaying: Boolean = false
    val isReady: Boolean = false
    val isPreparing: Boolean = false
    val isError: Boolean = false

//    fun sameMediaAsObject(other: Any?): Boolean {
//        if(other is String) {
//            return sameMediaAsUri(other)
//        }
//        return ((other is AudioPlayerState) && (this.mediaUri == other.mediaUri))
//    }

    fun isSameAsMediaItem(item: MediaItem?): Boolean {
        return this.mediaUri ==
                Uri.parse(item?.metadata?.getString(MediaMetadata.METADATA_KEY_MEDIA_URI)!!)
                ?: false
    }



}