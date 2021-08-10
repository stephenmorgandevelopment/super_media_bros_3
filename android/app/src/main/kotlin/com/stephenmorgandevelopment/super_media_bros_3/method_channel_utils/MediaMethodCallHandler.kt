package com.stephenmorgandevelopment.super_media_bros_3.method_channel_utils

import android.content.ContentResolver
import android.provider.MediaStore
import android.util.Log
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.AudioAccess
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.ImageAccess
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.MediaAccess
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.VideoAccess
import com.stephenmorgandevelopment.super_media_bros_3.models.Image
import com.stephenmorgandevelopment.super_media_bros_3.models.Media
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaQuery
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MediaMethodCallHandler(contentResolver: ContentResolver) : MethodChannel.MethodCallHandler {
    private val TAG = "MediaMethodCallHandler"

    private val mediaAccess: MediaAccess = MediaAccess(contentResolver)
    private val imageAccess: ImageAccess = ImageAccess(contentResolver)
    private val videoAccess: VideoAccess = VideoAccess(contentResolver)
    private val audioAccess: AudioAccess = AudioAccess(contentResolver)

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method) {
            // Media queries
            "getAllData" -> getAllData(result, call.argument<Media.Type>("type"))
            "getThumbnail" -> getThumbnail(result, call.argument<Media>("media"))

            // Image queries
            "getAllImagesData" -> getAllDataForAllImages(result)
            "getImageThumbnail" -> getImageThumbnail(result, call.argument<Image>("image"))
            "getImage" -> getImage(result, call.argument<Image>("image"))
            "getAllImagesBasicData" -> getAllImagesBasicData(result)
            "getAllImagesPathData" -> getAllImagesPathData(result)
            "getAllImageThumbnails" -> getAllImageThumbnails(result)
            "getData" -> getData(result, call.argument<Media>("media")!!)

            // Video queries
            "getAllVideosData" -> getAllVideosData(result)
            "getVideoThumbnail" -> getVideoThumbnail(result, call.argument<Media>("video"))

            // Audio queries
            "getAllAudioData" -> getAllAudioData(result, (call.argument<String>("groupBy") ?: "artist"))
            "getAlbumArtwork" -> getAlbumArtwork(result, call.argument<Media>("audio"))

            else -> result.notImplemented()
        }
    }

    private fun getAllData(result: MethodChannel.Result, type: Media.Type?) {
        val mediaList = when(type) {
            Media.Type.IMAGE -> imageAccess.query(MediaQuery.Assemble.allImagesData())    //getAllDataForAllImages(result)
            Media.Type.VIDEO -> videoAccess.query(MediaQuery.Assemble.allData())    //getAllVideosData(result)
            Media.Type.AUDIO -> audioAccess.query(MediaQuery.Assemble.allData()) //getAllAudioData(result)
            else -> ArrayList()
        }

        if (mediaList.isNotEmpty()) {
            result.success(mediaList)
        } else {
            result.error(
                    TAG,
                    "Error, check permissions.",
                    null)
        }
    }

    private fun getAllAudioData(result: MethodChannel.Result, groupBy: String) {
        val audioQuery = MediaQuery.Assemble.allData(groupBy)
        Log.i(TAG, "MediaQuery.sortBy = ${audioQuery.sortOrder}")

        val mediaList = audioAccess.query(audioQuery)

        if(mediaList.isNotEmpty()) {
            result.success(mediaList)
        } else {
            result.error(
                TAG,
                "Error, check permissions.",
                null)
        }
    }

    private fun getThumbnail(result: MethodChannel.Result, media: Media?) {
        if(media == null) {
            Log.d(TAG, "media was null.")
            result.error(TAG,
                    "media was null.",
                    null)
        }
        val thumbnail: ByteArray? = mediaAccess.getThumbnail(media!!)
        if(thumbnail != null) {
            result.success(thumbnail)
        } else {
            result.error(
                    TAG,
                    "thumbnail was empty null for ${media.metadata[MediaStore.MediaColumns.DISPLAY_NAME]}",
                    null)
        }
    }

//    private fun getAllAudioData(result: MethodChannel.Result) {
//        val mediaList: List<Media> = audioAccess.query(MediaQuery.Assemble.allImagesData())
//        if (mediaList.isNotEmpty()) {
//            result.success(mediaList)
//        } else {
//            result.error(
//                    TAG,
//                    "Error, check permissions.",
//                    null)
//        }
//    }

    private fun getAlbumArtwork(result: MethodChannel.Result, media: Media?) {
        if(media == null) {
            Log.i(TAG, "media is null")
            return
        }
        TODO("Call audioAccess.generateThumbnail")
    }

    private fun getAllVideosData(result: MethodChannel.Result) {
        val mediaList: List<Media> = videoAccess.query(MediaQuery.Assemble.allImagesData())
        if (mediaList.isNotEmpty()) {
            result.success(mediaList)
        } else {
            result.error(
                    TAG,
                    "Error, check permissions.",
                    null)
        }
    }

    private fun getVideoThumbnail(result: MethodChannel.Result, media: Media?) {
        if(media == null) {
            Log.i(TAG, "media is null")
            return
        }
        TODO("Call videoAccess.generateThumbnail")
    }

    private fun getData(result: MethodChannel.Result, media: Media?) {
        if(media == null) {
            Log.i(TAG, "media is null")
            return
        }
        val queryResult = imageAccess.query(MediaQuery.Assemble.imageData(media));
        if(queryResult.isNotEmpty()) {
            result.success(queryResult[0])
        } else {
            result.error(TAG,
                    "image was null.",
                    null)
        }
    }

    private fun getImage(result: MethodChannel.Result, media: Media?) {
        if(media == null) {
            Log.i(TAG, "media is null")
            return
        }
        val image = imageAccess.getImageAsByteArray(media as Image)
        if(image != null) {
            result.success(image)
        } else {
            result.error(
                    TAG,
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
                    TAG,
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
                    TAG,
                    "Error, check permissions.",
                    null)
        }
    }

    private fun getAllImagesPathData(result: MethodChannel.Result) {
        val imageList = imageAccess.getAllPathData()
        if(imageList.isNotEmpty()) {
            result.success(imageList)
        } else {
            result.error(TAG,
                    "Error, check permissions.",
                    null)
        }
    }

    private fun getImageThumbnail(result: MethodChannel.Result, image: Image?) {
        if(image == null) {
            Log.d(TAG, "image was null.")
            result.error("Android-Platform:getImageThumbnail()",
                    "image was null.",
                    null)
        }
        val thumbnail: ByteArray? = imageAccess.getImageThumbnail(image!!)
        if(thumbnail != null) {
            result.success(thumbnail)
        } else {
            result.error(
                    TAG,
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
                    TAG,
                    "compressedThumbnails is empty",
                    null)
        }
    }


}