package com.stephenmorgandevelopment.super_media_bros_3.models

import com.stephenmorgandevelopment.super_media_bros_3.preferences.MediaOptions


object MediaGroups {
    fun genGroupsFromList(mediaList: List<Media>) : List<MediaGroup> {
        val groupList = mutableListOf<MediaGroup>()
        val currentMediaList: MutableList<Media> = mutableListOf()

        var currentGroup = ""
        for(i in 0..mediaList.size) {
            val group = mediaList[i].metadata[MediaOptions.defaultGroupBy.value]

            if(group == null) {
                groupList.add(
                    com.stephenmorgandevelopment.super_media_bros_3.models.MediaGroup(
                        "nodata$i",
                        MediaOptions.defaultGroupBy,
                        listOf(mediaList[i])
                    )
                )
                continue
            }

            if(group != currentGroup) {
                groupList.add(
                    com.stephenmorgandevelopment.super_media_bros_3.models.MediaGroup(
                        group,
                        MediaOptions.defaultGroupBy,
                        currentMediaList
                    )
                )
                currentMediaList.clear()
                currentGroup = group
            }

            if(group == currentGroup) {
                currentMediaList.add(mediaList[i])
            }
        }

        return groupList
    }
}

data class MediaGroup(
    val name: String,
    val grouping: Audio.Category,
    val mediaList: List<Media>
) {
//    enum class By(val value: String) {
//        ALBUM("album"),
//        ARTIST("artist"),
//        GENRE("genre"),
//        PLAYLIST("playlist"),
//        FOLDER("folder")
//    }

}