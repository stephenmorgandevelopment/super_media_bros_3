package com.stephenmorgandevelopment.super_media_bros_3.models

import android.provider.BaseColumns
import android.provider.MediaStore
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.ImageAccess

import android.provider.MediaStore.MediaColumns.*

val ID_SELECTION = "${BaseColumns._ID} = ?"
val PATH_DATA_COLUMNS = arrayOf(_ID, DATA, DISPLAY_NAME, RELATIVE_PATH, VOLUME_NAME)

object Prefs {
    var date_taken = "datetaken"
//    enum class SortBy(name: String) {
//        DATE_TAKEN("datetaken")
//    }

}

data class MediaQuery(
        val projection: Array<String>?,
        val selection: String?,
        val selectionArgs: Array<String>?,
        val sortOrder: String?
) {
    object Assemble {
        fun allData(sortBy: String = Prefs.date_taken): MediaQuery =
                MediaQuery(null, null, null, sortBy)

        fun allImagesData(sortBy: String = Prefs.date_taken): MediaQuery =
                MediaQuery(null, null, null, sortBy)
        
        fun allImagesBasic(sortBy: String = ImageAccess.Prefs.sortOrder): MediaQuery =
                MediaQuery(Image.Columns.basicDataColumns, null, null, sortBy)
        
        fun allPathData(sortBy: String = Prefs.date_taken): MediaQuery =
                MediaQuery(PATH_DATA_COLUMNS, null, null, sortBy)
        
        fun pathDataById(long: Long, sortBy: String = Prefs.date_taken): MediaQuery =
                MediaQuery(
                        PATH_DATA_COLUMNS,
                        ID_SELECTION,
                        arrayOf(long.toString()),
                        sortBy)
        
        fun imageData(media: Media) : MediaQuery =
            MediaQuery(
                    PATH_DATA_COLUMNS,
                    ID_SELECTION,
                    arrayOf(media.metadata[_ID].toString()),
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