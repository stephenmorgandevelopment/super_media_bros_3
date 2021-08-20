package com.stephenmorgandevelopment.super_media_bros_3.mediastore

import android.content.ContentResolver
import android.content.ContentUris
import android.database.Cursor
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import com.stephenmorgandevelopment.super_media_bros_3.models.Audio
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaQuery

import android.provider.MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
import android.provider.MediaStore.Audio.AudioColumns.*
import com.stephenmorgandevelopment.super_media_bros_3.models.Media
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaGroup

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

    override fun query(query: MediaQuery): List<Media> {
        return super.query(query)
    }

}