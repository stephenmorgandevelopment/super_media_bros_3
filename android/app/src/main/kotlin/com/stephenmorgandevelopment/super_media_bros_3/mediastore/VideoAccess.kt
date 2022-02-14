package com.stephenmorgandevelopment.super_media_bros_3.mediastore

import android.content.ContentResolver
import android.content.ContentUris
import android.database.Cursor
import android.graphics.Bitmap
import android.provider.MediaStore
import com.stephenmorgandevelopment.super_media_bros_3.models.Media
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaQuery

import android.provider.MediaStore.Video.Media.EXTERNAL_CONTENT_URI
import android.provider.MediaStore.Video.VideoColumns.*
import android.util.Log
import android.util.Size
import com.stephenmorgandevelopment.super_media_bros_3.models.Video
import java.io.ByteArrayOutputStream


class VideoAccess(contentResolver: ContentResolver) : MediaAccess(contentResolver)  {
    override fun add(media: Media) {
        TODO("Not yet implemented")
    }

    override fun delete(media: Media): Boolean {
        TODO("Not yet implemented")
    }

    override fun getPathDataById(long: Long): Media? {
        TODO("Not yet implemented")
    }

    override fun getAllPathData(): List<Video> {
        return query(MediaQuery.Assemble.allPathData())
    }

    //TODO Test various uses of this vs EXTERNAL_CONTENT_URI
    val extVolume = MediaStore.Video.Media.getContentUri(MediaStore.VOLUME_EXTERNAL)

    override fun query(query: MediaQuery): List<Video> {
        val mediaList =  contentResolver.query(
                EXTERNAL_CONTENT_URI,
                query.projection,
                query.selection,
                query.selectionArgs,
                query.sortOrder
        )?.use { cursor -> processQuery(cursor) }

        return mediaList ?: ArrayList()
    }

    private fun processQuery(cursor: Cursor) : ArrayList<Video> {
        val medias = ArrayList<Video>()
        val idColumn = cursor.getColumnIndexOrThrow(_ID)

        while (cursor.moveToNext()) {
            val uri =
                    ContentUris.withAppendedId(EXTERNAL_CONTENT_URI, cursor.getLong(idColumn))

            val video = Video(uri)

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

            video.addMetadata(metadata)
            medias.add(video)
        }
        return medias
    }


}