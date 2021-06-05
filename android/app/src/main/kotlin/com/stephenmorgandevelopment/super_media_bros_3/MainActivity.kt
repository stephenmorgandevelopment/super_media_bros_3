package com.stephenmorgandevelopment.super_media_bros_3

import android.provider.MediaStore
import android.util.Log
import androidx.annotation.NonNull
import com.stephenmorgandevelopment.super_media_bros_3.flutter.*
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.ImageAccess
import com.stephenmorgandevelopment.super_media_bros_3.models.Image
import com.stephenmorgandevelopment.super_media_bros_3.models.Media
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaQuery

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec

private const val MEDIA_DATA_CHANNEL
    = "com.stephenmorgandevelopment.super_media_bros_3/media_data"

class MainActivity : FlutterActivity() {

    private lateinit var imageAccess: ImageAccess;

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        imageAccess = ImageAccess(contentResolver)

        MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                MEDIA_DATA_CHANNEL,
                StandardMethodCodec(FlutterMediaMessageCodec.INSTANCE)
        ).setMethodCallHandler { call, result ->
            when(call.method) {
                "getAllImagesData" -> getAllDataForAllImages(result)
                "getImageThumbnail" -> getImageThumbnail(result, call.argument<Image>("image"))
                "getAllImagesBasicData" -> getAllImagesBasicData(result)
                "getAllImagesPathData" -> getAllImagesPathData(result)
                "getAllImageThumbnails" -> getAllImageThumbnails(result)
                "getData" -> getData(result, call.argument<Media>("media")!!)
                else -> result.notImplemented()
            }
        }
    }

    private fun getData(result: MethodChannel.Result, media: Media?) {
        if(media == null) {
            Log.i("AndroidPlatform:getData()", "media is null")
            return
        }
        val img = (imageAccess.query(MediaQuery.Assemble.imageData(media)))[0]
        if(img != null) {
            result.success(img)
        } else {
            result.error("Android-Platform:getImageThumbnail()",
                    "image was null.",
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
