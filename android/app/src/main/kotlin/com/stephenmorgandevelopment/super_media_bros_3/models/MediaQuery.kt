package com.stephenmorgandevelopment.super_media_bros_3.models

import android.provider.BaseColumns
import android.provider.MediaStore
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.ImageAccess

val ID_SELECTION = "${BaseColumns._ID} = ?"

data class MediaQuery(
        val projection: Array<String>?,
        val selection: String?,
        val selectionArgs: Array<String>?,
        val sortOrder: String?
) {
    object Assemble {
        fun allImagesData(sortBy: String = ImageAccess.Prefs.sortOrder): MediaQuery =
                MediaQuery(null, null, null, sortBy)
        
        fun allImagesBasic(sortBy: String = ImageAccess.Prefs.sortOrder): MediaQuery =
                MediaQuery(Image.Columns.basicDataColumns, null, null, sortBy)
        
        fun allImagesPathData(sortBy: String = ImageAccess.Prefs.sortOrder): MediaQuery =
                MediaQuery(Image.Columns.pathDataColumns, null, null, sortBy)
        
        fun imagePathDataById(long: Long, sortBy: String = ImageAccess.Prefs.sortOrder): MediaQuery =
                MediaQuery(
                        Image.Columns.pathDataColumns,
                        ID_SELECTION,
                        arrayOf(long.toString()),
                        sortBy)
        
        fun imageData(media: Media) : MediaQuery =
            MediaQuery(
                    Image.Columns.pathDataColumns,
                    ID_SELECTION,
                    arrayOf(media.metadata[MediaStore.MediaColumns._ID].toString()),
                    null
            )

        
        fun basicVideo(): MediaQuery {
            return MediaQuery(arrayOf("TBD"), "TBD", arrayOf("TBD"), "TBD")
        }
        
        fun basicAudio(): MediaQuery {
            return MediaQuery(arrayOf("TBD"), "TBD", arrayOf("TBD"), "TBD")
        }
    }
}