package com.stephenmorgandevelopment.super_media_bros_3.mediastore

import android.content.ContentResolver
import android.content.ContentUris
import android.database.Cursor
import android.net.Uri
import android.provider.MediaStore
import com.stephenmorgandevelopment.super_media_bros_3.models.Audio
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaQuery
import com.stephenmorgandevelopment.super_media_bros_3.models.Media

class AudioAccess(contentResolver: ContentResolver) : MediaAccess(contentResolver) {
    var queryUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI

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

    fun queryBy(category: Audio.Category, query: MediaQuery): List<Audio> {
        queryUri = category.uri
        val mediaList = query(query)
        resetQueryUri()

        return mediaList
    }

    fun queryAlbums(query: MediaQuery): List<Audio> {
        return queryBy(Audio.Category.ALBUMS, query)
    }

    fun queryArtists(query: MediaQuery): List<Audio> {
        return queryBy(Audio.Category.ARTISTS, query)
    }

    fun queryGenres(query: MediaQuery): List<Audio> {
        return queryBy(Audio.Category.GENRES, query)
    }

    fun queryPlaylists(query: MediaQuery): List<Audio> {
        return queryBy(Audio.Category.PLAYLISTS, query)
    }

    override fun query(query: MediaQuery): List<Audio> {
        val mediaList =  contentResolver.query(
            queryUri,
            query.projection,
            query.selection,
            query.selectionArgs,
            query.sortOrder
        )?.use { cursor -> processQuery(cursor) }

        return mediaList ?: ArrayList()
    }

    private fun processQuery(cursor: Cursor) : ArrayList<Audio> {
        val medias = ArrayList<Audio>()
        val idColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.AudioColumns._ID)

        while (cursor.moveToNext()) {
            val uri =
                ContentUris.withAppendedId(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI, cursor.getLong(idColumn))

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

    private fun resetQueryUri() {
        queryUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
    }
}