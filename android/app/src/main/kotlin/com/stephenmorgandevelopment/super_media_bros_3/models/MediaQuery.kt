package com.stephenmorgandevelopment.supermediabros2.models

import android.provider.MediaStore
import com.stephenmorgandevelopment.supermediabros2.mediastore.ImageAccess

data class MediaQuery(
    val projection: Array<String>?,
    val selection: String?,
    val selectionArgs: Array<String>?,
    val sortOrder: String?
) {
    private lateinit var _MediaType : Media


    object Assemble {

        fun empty() : MediaQuery = MediaQuery(null, null, null, null)

        fun basicImage(): MediaQuery {
            return MediaQuery(
                    Image.Basic.basicDataColumns,
                    null,
                    null,
                    ImageAccess.Prefs.sortOrder
            )
        }

        fun basicVideo(): MediaQuery {
            return MediaQuery(arrayOf("TBD"), "TBD", arrayOf("TBD"), "TBD")
        }

        fun basicAudio(): MediaQuery {
            return MediaQuery(arrayOf("TBD"), "TBD", arrayOf("TBD"), "TBD")
        }
    }
}