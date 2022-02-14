package com.stephenmorgandevelopment.super_media_bros_3.models

import android.net.Uri
import android.provider.MediaStore
import android.media.Rating

abstract class Media(open val uri: Uri) {
    open lateinit var type: Type

    val metadata: MutableMap<String, String> = LinkedHashMap()

    open fun addMetadata(metadata: Map<String, String>) {
        this.metadata.putAll(metadata)
    }

    val displayName = metadata[MediaStore.MediaColumns.DISPLAY_NAME]

    fun getRating() : Rating? {


        return null
    }
 
    enum class Type {
        IMAGE, VIDEO, AUDIO
    }

    override fun equals(other: Any?): Boolean {
        return other is Media && other.uri == this.uri
    }

    override fun hashCode(): Int {
        return this.uri.hashCode()
    }
}