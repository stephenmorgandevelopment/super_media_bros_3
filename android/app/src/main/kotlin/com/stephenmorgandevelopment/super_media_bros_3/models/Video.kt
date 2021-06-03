package com.stephenmorgandevelopment.super_media_bros_3.models

import android.net.Uri

class Video(override val uri: Uri) : Media() {
    override var type = Type.VIDEO

    constructor(uri: Uri, metadata: Map<String, String>) : this(uri) {
        addMetadata(metadata)
    }
    //TODO Put a predefined Columns here for lightweight instances with limited metadata.
}