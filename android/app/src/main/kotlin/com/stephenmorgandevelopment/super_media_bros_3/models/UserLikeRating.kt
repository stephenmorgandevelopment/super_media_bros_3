package com.stephenmorgandevelopment.super_media_bros_3.models

import androidx.media2.common.Rating

class UserLikeRating(val isLiked: Boolean?) : Rating {
    var isDisliked: Boolean = false
        private set

    init {
        if(isLiked == false) {
            isDisliked = true
        }
    }

    override fun isRated(): Boolean {
        return isLiked ?: isDisliked
    }
}