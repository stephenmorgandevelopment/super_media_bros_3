package com.stephenmorgandevelopment.super_media_bros_3

import androidx.annotation.NonNull
import com.stephenmorgandevelopment.supermediabros2.mediastore.ImageAccess
import com.stephenmorgandevelopment.supermediabros2.models.MediaQuery
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

private const val MEDIA_DATA_CHANNEL = "com.stephenmorgandevelopment.super_media_bros_3/media_data"

class MainActivity : FlutterActivity() {

    private lateinit var imageAccess: ImageAccess;

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        imageAccess = ImageAccess(contentResolver)

        MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                MEDIA_DATA_CHANNEL
        ).setMethodCallHandler { call, result ->
            when(call.method) {
                "getAllImagesData" -> getAllDataForAllImages(result)
                "getAllImagesThumbnails" -> getAllImageThumbnails(result)
                "getAllImagesBasicData" -> getAllImagesBasicData(result)
                "getAllImagesPathData" -> getAllImagesPathData(result)
            }
        }
    }

    private fun getAllDataForAllImages(result: MethodChannel.Result) {
        val mediaList = imageAccess.query(MediaQuery.Assemble.allImagesData())
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
