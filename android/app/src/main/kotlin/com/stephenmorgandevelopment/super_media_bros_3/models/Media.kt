package com.stephenmorgandevelopment.supermediabros2.models

import android.net.Uri

abstract class Media {
    open val uri: Uri? = null
    open lateinit var type: Type

    open val metadata: MutableMap<String, String> = LinkedHashMap()

    open fun addMetadata(metadata: Map<String, String>) {
        this.metadata.putAll(metadata)
    }

    enum class Type {
        IMAGE, VIDEO, AUDIO
    }
}