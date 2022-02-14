package com.stephenmorgandevelopment.super_media_bros_3

import android.content.ContentResolver
import android.content.ContentUris
import android.graphics.Bitmap
import android.net.Uri
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.AudioAccess
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.ImageAccess
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.MediaAccess
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.VideoAccess
import com.stephenmorgandevelopment.super_media_bros_3.models.Image
import com.stephenmorgandevelopment.super_media_bros_3.models.Media
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaQuery

import com.stephenmorgandevelopment.super_media_bros_3.models.MediaQuery.Assemble as queries


// TODO Move all calls to MediaAccess and subclasses to here.
class MediaRepo(private val contentResolver: ContentResolver) {
    private val TAG = "MediaRepo"

    private val mediaAccess: MediaAccess = MediaAccess(contentResolver)
    private val imageAccess: ImageAccess = ImageAccess(contentResolver)
    private val videoAccess: VideoAccess = VideoAccess(contentResolver)
    private val audioAccess: AudioAccess = AudioAccess(contentResolver)

    fun getMediaById(id: String): Media? {
        val mediaList = audioAccess.query(
            queries.audioTrackDataForPlayerById(id)
        )

        return mediaList.firstOrNull()
    }

    fun getMediaByUri(uri: Uri): Media? {
        val id = ContentUris.parseId(uri)
        return getMediaById(id.toString())
    }

    fun getImageBytes(image: Image): ByteArray? {
        contentResolver.openInputStream(image.uri)?.use { stream ->
            return stream.readBytes()
        }
        return null
    }

    fun getThumbBitmap(media: Media): Bitmap? = mediaAccess.genBitmapThumbnail(media)
    fun getThumbBytes(media: Media): ByteArray? = mediaAccess.getThumbnail(media)

    fun getAllData(type: Media.Type?): List<Media> =
        accessMediaByType(type).query(queries.allData())

    fun getPathData(media: Media) =
        imageAccess.query(MediaQuery.Assemble.pathData(media)).let {
            if (it.isNotEmpty()) {
                it[0]
            } else {
                null
            }
        }


    fun getAllDataSorted(type: Media.Type?, groupBy: String): List<Media> {
        val sortQuery = MediaQuery.Assemble.allData(groupBy)

        return accessMediaByType(type).query(sortQuery)
    }

    private fun accessMediaByType(type: Media.Type?): MediaAccess {
        return when (type) {
            Media.Type.IMAGE -> imageAccess
            Media.Type.VIDEO -> videoAccess
            Media.Type.AUDIO -> audioAccess
            else -> mediaAccess
        }
    }

}