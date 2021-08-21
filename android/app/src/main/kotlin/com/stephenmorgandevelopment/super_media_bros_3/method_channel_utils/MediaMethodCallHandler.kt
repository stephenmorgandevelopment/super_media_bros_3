package com.stephenmorgandevelopment.super_media_bros_3.method_channel_utils

import android.content.ContentResolver
import android.provider.MediaStore
import android.util.Log
import com.stephenmorgandevelopment.super_media_bros_3.MediaRepo
import com.stephenmorgandevelopment.super_media_bros_3.models.Image
import com.stephenmorgandevelopment.super_media_bros_3.models.Media
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaQuery
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MediaMethodCallHandler(contentResolver: ContentResolver) : MethodChannel.MethodCallHandler {
    private val TAG = "MediaMethodCallHandler"

    private val repo = MediaRepo(contentResolver)

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            // Media queries
            "getAllData" -> getAllData(result, call.argument<Media.Type>("type"))
            "getThumbnail" -> getThumbnail(result, call.argument<Media>("media"))
            "getData" -> getPathData(result, call.argument<Media>("media")!!)

            // Image queries
            "getImage" -> getImage(result, call.argument<Image>("image"))

            // Audio queries
            "getAllAudioData" -> getAllAudioData(
                result,
                (call.argument<String>("groupBy") ?: "artist")
            )

            else -> result.notImplemented()
        }
    }

    private fun getAllData(result: MethodChannel.Result, type: Media.Type?) {
        val mediaList = repo.getAllData(type)

        if (mediaList.isNotEmpty()) {
            result.success(mediaList)
        } else {
            result.error(
                TAG,
                "Error, check permissions.",
                null
            )
        }
    }

    private fun getAllAudioData(result: MethodChannel.Result, groupBy: String) {
        val audioQuery = MediaQuery.Assemble.allData(groupBy)
        Log.i(TAG, "MediaQuery.sortBy = ${audioQuery.sortOrder}")

        val mediaList = repo.getAllDataSorted(Media.Type.AUDIO, groupBy)

        if (mediaList.isNotEmpty()) {
            result.success(mediaList)
        } else {
            result.error(
                TAG,
                "Error, check permissions.",
                null
            )
        }
    }

    private fun getThumbnail(result: MethodChannel.Result, media: Media?) {
        if (media == null) {
            Log.d(TAG, "media was null.")
            result.error(
                TAG,
                "media was null.",
                null
            )
        }
        val thumbnail: ByteArray? = repo.getThumbBytes(media!!)
        if (thumbnail != null) {
            result.success(thumbnail)
        } else {
            result.error(
                TAG,
                "thumbnail was empty null for ${media.metadata[MediaStore.MediaColumns.DISPLAY_NAME]}",
                null
            )
        }
    }

    private fun getPathData(result: MethodChannel.Result, media: Media?) {
        if (media == null) {
            Log.i(TAG, "media is null")
            return
        }

        val queryResult = repo.getPathData(media)
        if (queryResult != null) {
            result.success(queryResult)
        } else {
            result.error(
                TAG,
                "image was null.",
                null
            )
        }
    }

    private fun getImage(result: MethodChannel.Result, media: Media?) {
        if (media == null) {
            Log.i(TAG, "media is null")
            return
        }
        val image = repo.getImageBytes(media as Image)
        if (image != null) {
            result.success(image)
        } else {
            result.error(
                TAG,
                "image was empty null for ${media.metadata[MediaStore.MediaColumns.DISPLAY_NAME]}",
                null
            )
        }
    }
}