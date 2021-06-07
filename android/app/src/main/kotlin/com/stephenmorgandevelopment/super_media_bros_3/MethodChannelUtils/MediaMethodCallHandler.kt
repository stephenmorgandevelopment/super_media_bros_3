package com.stephenmorgandevelopment.super_media_bros_3.MethodChannelUtils

import android.content.ContentResolver
import android.provider.MediaStore
import android.util.Log
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.AudioAccess
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.ImageAccess
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.VideoAccess
import com.stephenmorgandevelopment.super_media_bros_3.models.Image
import com.stephenmorgandevelopment.super_media_bros_3.models.Media
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaQuery
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MediaMethodCallHandler(contentResolver: ContentResolver) : MethodChannel.MethodCallHandler {
    private var imageAccess: ImageAccess = ImageAccess(contentResolver)
    private var videoAccess: VideoAccess = VideoAccess(contentResolver)
    private var audioAccess: AudioAccess = AudioAccess(contentResolver)

    init {
//        imageAccess = ImageAccess(contentResolver)
//        videoAccess = VideoAccess(contentResolver)
//        audioAccess = AudioAccess(contentResolver)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method) {
            "getAllImagesData" -> getAllDataForAllImages(result)
            "getImageThumbnail" -> getImageThumbnail(result, call.argument<Image>("image"))
            "getImage" -> getImage(result, call.argument<Image>("image"))
            "getAllImagesBasicData" -> getAllImagesBasicData(result)
            "getAllImagesPathData" -> getAllImagesPathData(result)
            "getAllImageThumbnails" -> getAllImageThumbnails(result)
            "getData" -> getData(result, call.argument<Media>("media")!!)
            else -> result.notImplemented()
        }
    }

    private fun getData(result: MethodChannel.Result, media: Media?) {
        if(media == null) {
            Log.i("AndroidPlatform:getData()", "media is null")
            return
        }
        val queryResult = imageAccess.query(MediaQuery.Assemble.imageData(media));
        if(queryResult.isNotEmpty()) {
            result.success(queryResult[0])
        } else {
            result.error("Android-Platform:getImageThumbnail()",
                    "image was null.",
                    null)
        }
    }

    private fun getImage(result: MethodChannel.Result, media: Media?) {
        if(media == null) {
            Log.i("AndroidPlatform:getData()", "media is null")
            return
        }
        val image = imageAccess.getImageAsByteArray(media as Image)
        if(image != null) {
            result.success(image)
        } else {
            result.error(
                    "Android-Platform:getImageThumbnail()",
                    "image was empty null for ${media.metadata[MediaStore.MediaColumns.DISPLAY_NAME]}",
                    null)
        }
    }

    private fun getAllDataForAllImages(result: MethodChannel.Result) {
        val mediaList: List<Media> = imageAccess.query(MediaQuery.Assemble.allImagesData())
        if (mediaList.isNotEmpty()) {
            result.success(mediaList)
        } else {
            result.error(
                    "Android-Platform",
                    "Error, check permissions.",
                    null)
        }
    }

    private fun getAllImagesBasicData(result: MethodChannel.Result) {
        val mediaList = imageAccess.query(MediaQuery.Assemble.allImagesBasic())
        if (mediaList.isNotEmpty()) {
            result.success(mediaList)
        } else {
            result.error(
                    "Android-Platform",
                    "Error, check permissions.",
                    null)
        }
    }

    private fun getAllImagesPathData(result: MethodChannel.Result) {
        val imageList = imageAccess.getAllPathData()
        if(imageList.isNotEmpty()) {
            result.success(imageList)
        } else {
            result.error("Android-Platform",
                    "Error, check permissions.",
                    null)
        }
    }

    private fun getImageThumbnail(result: MethodChannel.Result, image: Image?) {
        if(image == null) {
            Log.d("Android-Platform-MainActivity", "image was null.")
            result.error("Android-Platform:getImageThumbnail()",
                    "image was null.",
                    null)
        }
        val thumbnail: ByteArray? = imageAccess.getImageThumbnail(image!!)
        if(thumbnail != null) {
            result.success(thumbnail)
        } else {
            result.error(
                    "Android-Platform:getImageThumbnail()",
                    "thumbnail was empty null for ${image.metadata[MediaStore.MediaColumns.DISPLAY_NAME]}",
                    null)
        }
    }

    private fun getAllImageThumbnails(result: MethodChannel.Result) {
        val thumbnails = imageAccess.getAllThumbnailsForImages()

        if(thumbnails != null) {
            result.success(thumbnails)
        } else {
            result.error(
                    "getAllThumbnailsForImages",
                    "compressedThumbnails is empty",
                    null)
        }
    }


}