package com.stephenmorgandevelopment.super_media_bros_3.mediastore

import android.annotation.SuppressLint
import android.content.ContentResolver
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.provider.MediaStore
import android.util.Log
import android.util.Size
import com.stephenmorgandevelopment.super_media_bros_3.FeatureSet
import com.stephenmorgandevelopment.super_media_bros_3.featureSet
import com.stephenmorgandevelopment.super_media_bros_3.models.Media
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaQuery
import java.io.ByteArrayOutputStream


interface MediaStoreWrapper {
    fun query(query: MediaQuery): List<Media>

    fun add(media: Media)

    fun delete(media: Media): Boolean

    fun getPathDataById(long: Long): Media?

    fun getAllPathData(): List<Media>?

    fun getThumbnail(media: Media): ByteArray?

//    fun genBitmapThumbnail(media: Media) : Bitmap?
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

    @SuppressLint("NewApi") // Needed because the compiler isn't smart enough to
    // realize that featureSet is actually checking the API for proper versioning.
    fun genBitmapThumbnail(media: Media) : Bitmap? {
        val thumb: Bitmap?
        if (featureSet == FeatureSet.FULL) {
            thumb = contentResolver.loadThumbnail(media.uri, Options.thumbsize, null)
        } else {
            thumb = when (media.type) {
                Media.Type.IMAGE -> MediaStore.Images.Thumbnails.getThumbnail(
                    contentResolver,
                    media.metadata["_id"]!!.toLong(),
                    MediaStore.Images.Thumbnails.MICRO_KIND,
                    null
                )

                Media.Type.VIDEO -> MediaStore.Video.Thumbnails.getThumbnail(
                    contentResolver,
                    media.metadata["_id"]!!.toLong(),
                    MediaStore.Images.Thumbnails.MICRO_KIND,
                    null
                )

                Media.Type.AUDIO -> BitmapFactory.decodeFile(media.metadata["album_art"])
            }
        }

        return thumb
    }

    // TODO Revert if this fails for any reason.  Been working BONKERS!!!!!
    protected fun generateThumbnail(media: Media): ByteArray? {
        val outputStream = ByteArrayOutputStream()
        val success = genBitmapThumbnail(media)
            ?.compress(Bitmap.CompressFormat.JPEG, 75, outputStream)
            ?: false

        return if (success) {
            Log.i(
                "ImageAccess-Kotlin",
                "Successfully made thumbnail for ${media.metadata[MediaStore.Images.ImageColumns.DISPLAY_NAME]}"
            )
            outputStream.toByteArray()
        } else {
            null
        }
    }
}