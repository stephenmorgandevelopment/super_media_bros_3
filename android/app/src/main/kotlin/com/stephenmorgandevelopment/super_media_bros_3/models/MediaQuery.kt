package com.stephenmorgandevelopment.super_media_bros_3.models

import android.annotation.SuppressLint
import android.provider.BaseColumns
import android.provider.MediaStore.Audio.AudioColumns
import android.provider.MediaStore
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.ImageAccess

import android.provider.MediaStore.MediaColumns.*
import com.stephenmorgandevelopment.super_media_bros_3.FeatureSet
import com.stephenmorgandevelopment.super_media_bros_3.MainActivity
import com.stephenmorgandevelopment.super_media_bros_3.featureSet

const val ID_SELECTION = "${BaseColumns._ID} = ?"
val PATH_DATA_COLUMNS = when (featureSet) {
    FeatureSet.FULL -> arrayOf(_ID, DATA, DISPLAY_NAME, RELATIVE_PATH, VOLUME_NAME)
    else -> arrayOf(_ID, DATA, DISPLAY_NAME)
}



class MediaQuery(
        val projection: Array<String>?,
        val selection: String?,
        val selectionArgs: Array<String>?,
        val sortOrder: String?
) {
    object Assemble {
        fun allData(sortBy: String = SortBy.date_taken): MediaQuery =
                MediaQuery(null, null, null, sortBy)

        fun allImagesData(sortBy: String = SortBy.date_taken): MediaQuery =
                MediaQuery(null, null, null, sortBy)
        
        fun allImagesBasic(sortBy: String = ImageAccess.Prefs.sortOrder): MediaQuery =
                MediaQuery(Image.Columns.basicDataColumns, null, null, sortBy)
        
        fun allPathData(sortBy: String = SortBy.date_taken): MediaQuery =
                MediaQuery(PATH_DATA_COLUMNS, null, null, sortBy)
        
        fun pathDataById(long: Long, sortBy: String = SortBy.date_taken): MediaQuery =
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

        fun allAlbums(sortBy: String = SortBy.chain(SortBy.albums, SortBy.abc_asc)) : MediaQuery = MediaQuery(
            null,
            null,
            null,
            sortBy
        )

        fun audioTrackDataForPlayerById(id: String): MediaQuery =
            MediaQuery(
                Columns.forAudioPlayer(),
                ID_SELECTION,
                arrayOf(id),
                null
            )
        
        fun basicVideo(): MediaQuery {
            return MediaQuery(arrayOf("TBD"), "TBD", arrayOf("TBD"), "TBD")
        }
        
        fun basicAudio(): MediaQuery {
            return MediaQuery(arrayOf("TBD"), "TBD", arrayOf("TBD"), "TBD")
        }
    }

    object SortBy {
        const val date_taken = "datetaken"
        const val abc_asc = "_display_name ASC"
        const val abc_desc = "_display_name DESC"
        val albums = MediaGroup.By.ALBUM.value
        const val plus = ", "

        fun chain(vararg sortBy: String) : String {
            var orderBy: String = sortBy.first()
            for(order in sortBy) {
                if(orderBy != order) {
                    orderBy += (plus + order)
                }
            }

            return orderBy
        }
    }

    object Columns {
        @SuppressLint("InlinedApi")  // Unsure if this is an issue
        // TODO Dig through code to verify that this is just a documentation glitch.
        // TODO I beleive they changed the underlying class structure, but not the constants or vals.
        fun forAudioPlayer() : Array<String> {
            return arrayOf(_ID, DISPLAY_NAME, ALBUM_ARTIST, ARTIST, ALBUM, BUCKET_DISPLAY_NAME,
                CD_TRACK_NUMBER, DURATION, IS_DRM, IS_FAVORITE,
                AudioColumns.IS_AUDIOBOOK, AudioColumns.IS_MUSIC, AudioColumns.IS_PODCAST,
                OWNER_PACKAGE_NAME, VOLUME_NAME, DATA)
        }
    }
}