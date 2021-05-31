package com.stephenmorgandevelopment.supermediabros2.mediastore

import com.stephenmorgandevelopment.supermediabros2.models.Media
import com.stephenmorgandevelopment.supermediabros2.models.MediaQuery

interface MediaStoreWrapper {

    fun query(query: MediaQuery) : List<Media>

    fun add(media: Media)

    fun delete(media: Media) : Boolean
}