package com.stephenmorgandevelopment.supermediabros2.models

import android.annotation.SuppressLint
import android.net.Uri
import android.provider.MediaStore.Images.ImageColumns.*

class Image(override val uri: Uri) : Media() {
    override var type = Type.IMAGE
    
    @SuppressLint("InlinedApi")
   

    object Basic {
        val basicDataColumns = arrayOf(_ID, BUCKET_DISPLAY_NAME, DISPLAY_NAME, DATE_TAKEN, ORIENTATION, IS_PRIVATE)
        
    }
    
}