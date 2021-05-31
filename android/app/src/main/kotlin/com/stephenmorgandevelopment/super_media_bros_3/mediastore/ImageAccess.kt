package com.stephenmorgandevelopment.supermediabros2.mediastore

import android.annotation.SuppressLint
import android.content.ContentResolver
import android.content.ContentUris
import android.database.Cursor
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.provider.MediaStore
import com.stephenmorgandevelopment.supermediabros2.models.Image
import com.stephenmorgandevelopment.supermediabros2.models.Media
import com.stephenmorgandevelopment.supermediabros2.models.MediaQuery
import java.util.*
import kotlin.collections.LinkedHashMap
import android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI
import io.flutter.plugin.common.MethodChannel

import android.provider.MediaStore.Images.ImageColumns.*
import android.util.Log
import java.io.ByteArrayOutputStream
import java.io.OutputStream
import kotlin.collections.ArrayList

class ImageAccess(
        val contentResolver: ContentResolver
) : MediaStoreWrapper {
    object Prefs {
        var sortOrder = "datetaken"
    }
    
    
    override fun add(media: Media) {
        TODO("Not yet implemented")
    }
    
    override fun delete(media: Media): Boolean {
        TODO("Not yet implemented")
    }
    
    override fun query(query: MediaQuery): List<Image> {
        val medias = ArrayList<Image>()
        
        contentResolver.query(
                EXTERNAL_CONTENT_URI,
                query.projection,
                query.selection,
                query.selectionArgs,
                query.sortOrder
        )?.use { cursor -> processQuery(cursor, medias) }
        
        return medias
    }
    
    private fun processQuery(cursor: Cursor, medias: ArrayList<Image>) {//: ArrayList<Image> {
        val idColumn = cursor.getColumnIndexOrThrow(MediaStore.Images.ImageColumns._ID)
        
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
//        return medias
    }
    
    fun getImageAsByteArray(image: Image) : ByteArray? {
        contentResolver.openInputStream(image.uri)?.use { stream ->
            return  stream.readBytes()
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
    
    @SuppressLint("InlinedApi")
//    fun getAllThumbnailsForImages(result: MethodChannel.Result) {
    fun getAllThumbnailsForImages() : List<ByteArray>? {
        val mediaList = query(MediaQuery.Assemble.basicImage())
        
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
        contentResolver.openInputStream(image.uri)?.use { stream ->
            val tmpBitmap = Bitmap.createScaledBitmap(
                    BitmapFactory.decodeStream(stream),
                    320,
                    240,
                    true)
            
            val outputStream = ByteArrayOutputStream()
            val success = tmpBitmap.compress(Bitmap.CompressFormat.JPEG, 75, outputStream)
            
            return if (success) {
                outputStream.toByteArray()
            } else {
                null
            }
        }
        return null
    }
}