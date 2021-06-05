package com.stephenmorgandevelopment.super_media_bros_3.mediastore

import com.stephenmorgandevelopment.super_media_bros_3.models.Media
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaQuery


interface MediaStoreWrapper {

    fun query(query: MediaQuery) : List<Media>

    fun add(media: Media)

    fun delete(media: Media) : Boolean
    
    fun getPathDataById(long: Long): Media

    fun getAllPathData(): List<Media>

}