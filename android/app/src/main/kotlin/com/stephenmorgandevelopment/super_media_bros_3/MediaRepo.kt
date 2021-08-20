package com.stephenmorgandevelopment.super_media_bros_3

import android.content.ContentResolver
import android.content.ContentUris
import android.graphics.Bitmap
import android.net.Uri
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.AudioAccess
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.ImageAccess
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.MediaAccess
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.VideoAccess
import com.stephenmorgandevelopment.super_media_bros_3.models.Audio
import com.stephenmorgandevelopment.super_media_bros_3.models.Media
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaQuery


// TODO Move all calls to MediaAccess and subclasses to here.
class MediaRepo(contentResolver: ContentResolver) {
    private val TAG = "MediaRepo"

    private val mediaAccess: MediaAccess = MediaAccess(contentResolver)
    private val imageAccess: ImageAccess = ImageAccess(contentResolver)
    private val videoAccess: VideoAccess = VideoAccess(contentResolver)
    private val audioAccess: AudioAccess = AudioAccess(contentResolver)

    fun getMediaById(id: String): Media? {
        val mediaList = audioAccess.query(
            MediaQuery.Assemble.audioTrackDataForPlayerById(id))

        return mediaList.firstOrNull()
    }

    fun getMediaByUri(uri: Uri): Media? {
        val id = ContentUris.parseId(uri)
        return getMediaById(id.toString())
    }

    fun getThumbBitmap(media: Media) : Bitmap? = mediaAccess.genBitmapThumbnail(media)


}