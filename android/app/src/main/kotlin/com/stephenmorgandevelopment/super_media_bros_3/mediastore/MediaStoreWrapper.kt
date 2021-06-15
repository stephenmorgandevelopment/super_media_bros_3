package com.stephenmorgandevelopment.super_media_bros_3.mediastore

import android.content.ContentResolver
import android.content.ContentUris
import android.database.Cursor
import android.graphics.Bitmap
import android.net.Uri
import android.provider.MediaStore
import android.util.Log
import android.util.Size
import com.stephenmorgandevelopment.super_media_bros_3.models.Image
import com.stephenmorgandevelopment.super_media_bros_3.models.Media
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaQuery
import java.io.ByteArrayOutputStream


interface MediaStoreWrapper {
    fun query(query: MediaQuery) : List<Media>

    fun add(media: Media)

    fun delete(media: Media) : Boolean

    fun getPathDataById(long: Long): Media?

    fun getAllPathData(): List<Media>?

    fun getThumbnail(media: Media): ByteArray?
}

open class MediaAccess(protected val contentResolver: ContentResolver) : MediaStoreWrapper {
    object Options {
        var thumbsize = Size(320, 240)
    }


    override fun query(query: MediaQuery): List<Media> {
        TODO("Not yet implemented")
    }

    override fun add(media: Media) {
        TODO("Not yet implemented")
    }

    override fun delete(media: Media): Boolean {
        TODO("Not yet implemented")
    }

    override fun getPathDataById(long: Long): Media? {
        TODO("Not yet implemented")
    }

    override fun getAllPathData(): List<Media>? {
        TODO("Not yet implemented")
    }

    override fun getThumbnail(media: Media): ByteArray? = generateThumbnail(media)

    protected fun generateThumbnail(media: Media): ByteArray? {
        val thumb = contentResolver.loadThumbnail(media.uri, Options.thumbsize, null)

        val outputStream = ByteArrayOutputStream()
        val success = thumb.compress(Bitmap.CompressFormat.JPEG, 75, outputStream)

        return if (success) {
            Log.i("ImageAccess-Kotlin", "Successfully made thumbnail for ${media.metadata[MediaStore.Images.ImageColumns.DISPLAY_NAME]}")
            outputStream.toByteArray()
        } else {
            null
        }
    }
}