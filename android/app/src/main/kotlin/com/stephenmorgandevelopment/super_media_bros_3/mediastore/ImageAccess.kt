package com.stephenmorgandevelopment.super_media_bros_3.mediastore

import android.content.ContentResolver
import android.content.ContentUris
import android.database.Cursor
import android.graphics.Bitmap

import java.util.*
import kotlin.collections.LinkedHashMap
import android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI

import android.provider.MediaStore.Images.ImageColumns.*
import android.util.Log
import android.util.Size
import com.stephenmorgandevelopment.super_media_bros_3.models.Image
import com.stephenmorgandevelopment.super_media_bros_3.models.Media
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaQuery

import java.io.ByteArrayOutputStream
import kotlin.collections.ArrayList

class ImageAccess(val contentResolver: ContentResolver) : MediaStoreWrapper {
    object Prefs {
        var sortOrder = "datetaken"
    }

    override fun getPathDataById(long: Long): Image {
        return query(MediaQuery.Assemble.pathDataById(long))[0]
    }

    override fun getAllPathData(): List<Image> {
        return query(MediaQuery.Assemble.allImagesPathData())
    }

    override fun add(media: Media) {
        TODO("Not yet implemented")
    }
    
    override fun delete(media: Media): Boolean {
        TODO("Not yet implemented")
    }
    
    override fun query(query: MediaQuery): List<Image> {
        val mediaList =  contentResolver.query(
                EXTERNAL_CONTENT_URI,
                query.projection,
                query.selection,
                query.selectionArgs,
                query.sortOrder
        )?.use { cursor -> processQuery(cursor) }
        
        return mediaList ?: ArrayList()
    }
    
    private fun processQuery(cursor: Cursor) : ArrayList<Image> {//: ArrayList<Image> {
        val medias = ArrayList<Image>()
        val idColumn = cursor.getColumnIndexOrThrow(_ID)
        
        while (cursor.moveToNext()) {
            val uri =
                    ContentUris.withAppendedId(EXTERNAL_CONTENT_URI, cursor.getLong(idColumn))
            
            val image = Image(uri)
            
            val metadata: MutableMap<String, String> = LinkedHashMap()
            loop@ for (column in 0 until cursor.columnCount) {
                when {
                    cursor.getType(column) == Cursor.FIELD_TYPE_NULL ->
                        continue@loop
                    
                    cursor.getType(column) == Cursor.FIELD_TYPE_STRING ->
                        metadata[cursor.getColumnName(column)] = cursor.getString(column)
                    
                    cursor.getType(column) == Cursor.FIELD_TYPE_BLOB ->
                        metadata[cursor.getColumnName(column)] = cursor.getBlob(column).toString()
                    
                    cursor.getType(column) == Cursor.FIELD_TYPE_FLOAT ->
                        metadata[cursor.getColumnName(column)] = cursor.getFloat(column).toString()
                    
                    cursor.getType(column) == Cursor.FIELD_TYPE_INTEGER ->
                        metadata[cursor.getColumnName(column)] = cursor.getInt(column).toString()
                }
            }
            
            image.addMetadata(metadata)
            medias.add(image)
        }
        return medias
    }

//    fun getImageAsFile(image: Image) : File? {
//        try {
//            return File(image.uri.path!!)
//        } catch(e: Exception) {
//            Log.d("ImageAccess-kotlin", e.message.toString());
//        }
//        return null;
//    }
    
    fun getImageAsByteArray(image: Image) : ByteArray? {
        contentResolver.openInputStream(image.uri)?.use { stream ->
            return stream.readBytes()
        }
        return null
    }

    fun getListOfImagesAsListOfByteArrays(images: List<Image>) : List<ByteArray>? {
        val byteArrayList = ArrayList<ByteArray>()

        for(image in images) {
            contentResolver.openInputStream(image.uri)?.use { stream ->
                byteArrayList.add(stream.readBytes())
            }
        }

        return if(byteArrayList.isNotEmpty()) {
            byteArrayList
        } else {
            null
        }
    }

//    fun getAllThumbnailsForImages(result: MethodChannel.Result) {
    fun getImageThumbnail(image: Image): ByteArray? = generateThumbnail(image) //?: byteArrayOf()
    
    fun getImageThumbnailsAsByteArray(images: List<Image>) : List<ByteArray> {
        val compressedThumbnails: ArrayList<ByteArray> = ArrayList()
    
        for (image in images) {
            val thumbnail = generateThumbnail(image)
            if (thumbnail != null) {
                compressedThumbnails.add(thumbnail)
            } else {
                Log.e("ImageAccess", "Failed to create thumbnail for ${image.metadata[DISPLAY_NAME]}.")
            }
        }
    
        return compressedThumbnails
    }
    
    fun getAllThumbnailsForImages() : List<ByteArray>? {
        val mediaList = query(MediaQuery.Assemble.allImagesBasic())
        
        val compressedThumbnails: ArrayList<ByteArray> = ArrayList()
        for (image in mediaList) {
            val thumbnail = generateThumbnail(image)
            if (thumbnail != null) {
                compressedThumbnails.add(thumbnail)
            } else {
                Log.e("ImageAccess", "Failed to create thumbnail for ${image.metadata[DISPLAY_NAME]}.")
            }
        }
        
        return if (compressedThumbnails.isNotEmpty()) {
            compressedThumbnails
        } else {
            Log.d("ImageAccess", "compressedThumbnails empty - mediaList contained ${mediaList.size} entries.")
            null
        }
    }
    
    private fun generateThumbnail(image: Image): ByteArray? {
        val thumb = contentResolver.loadThumbnail(image.uri, Size(320, 240), null)
    
        val outputStream = ByteArrayOutputStream()
        val success = thumb.compress(Bitmap.CompressFormat.JPEG, 75, outputStream)
    
        return if (success) {
            Log.i("ImageAccess-Kotlin", "Successfully made thumbnail for ${image.metadata[DISPLAY_NAME]}")
            outputStream.toByteArray()
        } else {
            null
        }
    }
}