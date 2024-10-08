package com.stephenmorgandevelopment.super_media_bros_3.mediastore

import android.content.ContentResolver
import android.content.ContentUris
import android.database.Cursor
import android.graphics.Bitmap
import com.stephenmorgandevelopment.super_media_bros_3.models.Audio
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaQuery

import android.provider.MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
import android.provider.MediaStore.Audio.AudioColumns.*
import android.util.Log
import android.util.Size
import com.stephenmorgandevelopment.super_media_bros_3.models.Media
import java.io.ByteArrayOutputStream

class AudioAccess(contentResolver: ContentResolver) : MediaAccess(contentResolver) {
    override fun add(media: Media) {
        TODO("Not yet implemented")
    }

    override fun delete(media: Media): Boolean {
        TODO("Not yet implemented")
    }

    override fun getPathDataById(long: Long): Media? {
        TODO("Not yet implemented")
    }

    override fun getAllPathData(): List<Media> {
        return query(MediaQuery.Assemble.allPathData())
    }

    override fun query(query: MediaQuery): List<Audio> {
        val mediaList =  contentResolver.query(
                EXTERNAL_CONTENT_URI,
                query.projection,
                query.selection,
                query.selectionArgs,
                query.sortOrder
        )?.use { cursor -> processQuery(cursor) }

        return mediaList ?: ArrayList()
    }

    private fun processQuery(cursor: Cursor) : ArrayList<Audio> {
        val medias = ArrayList<Audio>()
        val idColumn = cursor.getColumnIndexOrThrow(_ID)

        while (cursor.moveToNext()) {
            val uri =
                    ContentUris.withAppendedId(EXTERNAL_CONTENT_URI, cursor.getLong(idColumn))

            val audio = Audio(uri)

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
    
            audio.addMetadata(metadata)
            medias.add(audio)
        }
        return medias
    }
}