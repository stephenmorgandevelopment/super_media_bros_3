package com.stephenmorgandevelopment.super_media_bros_3.preferences

import android.graphics.Color
import com.stephenmorgandevelopment.super_media_bros_3.models.Audio
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaGroup


// TODO Pull values from shared preferences.
// TODO These will either be saved from the flutter side, or passed here to be
// TODO saved from the MediaOptions class in flutter.
object MediaOptions {

    // Misc Options
    val defaultGroupBy = Audio.Category.ALBUMS

    // Times
    val seekForwardTime = 7500
    val seekBackwardsTime = 3500

    // Sizes
    val  iconsize = 48.0
    val  videoPlayBtnMultiplier = 2.25
    val playBtnMultiplier = videoPlayBtnMultiplier / 1.5
    val fabSize = 48.0

    // Colors
    val  selectedColor = Color.argb(152, 82, 255, 31);
    val  controlGroupBackgroundColor = Color.argb(165, 145, 145, 145)
    val fabBackgroundColor = Color.argb(215, 195, 195, 195)
    val superMediaButtonColor = Color.argb(205, 235, 235, 235)
    val dragHighlightColor = Color.argb(139, 255, 157, 0)
    val speedSelectorBackground = Color.argb(198, 56, 234, 169)
}