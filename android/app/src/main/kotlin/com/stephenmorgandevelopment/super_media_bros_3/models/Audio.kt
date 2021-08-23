package com.stephenmorgandevelopment.super_media_bros_3.models

import android.net.Uri
import android.provider.MediaStore
import androidx.media2.common.MediaMetadata

class Audio(uri: Uri) : Media(uri) {
    override var type = Type.AUDIO
    
    constructor(uri: Uri, metadata: Map<String, String>) : this(uri) {
        addMetadata(metadata)
    }

    enum class Category(val uri: Uri, val value: String) {
        ALBUMS(MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI, "album"),
        ARTISTS(MediaStore.Audio.Artists.EXTERNAL_CONTENT_URI, "artist"),
        GENRES(MediaStore.Audio.Genres.EXTERNAL_CONTENT_URI, "genre"),
        PLAYLISTS(MediaStore.Audio.Playlists.EXTERNAL_CONTENT_URI, "playlist"),

        // May be removed to better support Scoped storage.
        FOLDER(MediaStore.Downloads.EXTERNAL_CONTENT_URI, "folder")
    }

//    object Builder {
//        fun fromMediaMetadata(mediaMetadata: MediaMetadata) {
//            val contentUri
//                = Uri.parse(mediaMetadata.getString(MediaMetadata.METADATA_KEY_MEDIA_URI))
//
//            val metadata = mediaMetadata.keySet().filterNot {
//                it == MediaMetadata.METADATA_KEY_MEDIA_URI
//
//            }.map {
////                val entry: Map.Entry<String, String> = MutableMap.MutableEntry
//                val value = mediaMetadata.getObject(it)
//                val pair = Pair<String, String>(it, )
//
//
//            }
//
//            val audio = Audio(contentUri)
//
////            val metadata = LinkedHashMap<String, String>()
////            for(key in mediaMetadata.keySet()) {
////
////            }
//        }
//    }

}