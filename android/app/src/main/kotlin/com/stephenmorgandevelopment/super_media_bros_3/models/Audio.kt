package com.stephenmorgandevelopment.super_media_bros_3.models

import android.net.Uri
import android.provider.MediaStore
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.AudioAccess

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

}