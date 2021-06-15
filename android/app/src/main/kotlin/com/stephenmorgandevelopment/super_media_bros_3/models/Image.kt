package com.stephenmorgandevelopment.super_media_bros_3.models

import android.annotation.SuppressLint
import android.net.Uri
import android.provider.MediaStore.Images.ImageColumns.*
import java.lang.reflect.Constructor

class Image(uri: Uri) : Media(uri) {
    override var type = Type.IMAGE
    
    constructor(uri: Uri, metadata: Map<String, String>) : this(uri) {
        addMetadata(metadata)
    }
    
    @SuppressLint("InlinedApi")
    object Columns {
        val basicDataColumns =
                arrayOf(_ID, BUCKET_DISPLAY_NAME, DISPLAY_NAME,
                        DATE_TAKEN, ORIENTATION, IS_PRIVATE, DATA)
    }
    
}