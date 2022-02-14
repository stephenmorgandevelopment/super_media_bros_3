package com.stephenmorgandevelopment.super_media_bros_3.mediasession

import android.content.Context
import android.support.v4.media.session.PlaybackStateCompat
import androidx.core.app.NotificationCompat
import androidx.media.session.MediaButtonReceiver
import com.stephenmorgandevelopment.super_media_bros_3.R

object NotificationActions {

    fun playPause(context: Context) : NotificationCompat.Action {
        return NotificationCompat.Action(
            R.drawable.media_session_service_notification_ic_pause,
            "pause",
            MediaButtonReceiver.buildMediaButtonPendingIntent(
                context,
                PlaybackStateCompat.ACTION_PLAY_PAUSE
            )
        )
    }

    fun prevTrack(context: Context) : NotificationCompat.Action {
        return NotificationCompat.Action(
            R.drawable.media_session_service_notification_ic_skip_to_previous,
            "prev",
            MediaButtonReceiver.buildMediaButtonPendingIntent(
                context,
                PlaybackStateCompat.ACTION_SKIP_TO_PREVIOUS
            )
        )
    }

    fun nextTrack(context: Context) : NotificationCompat.Action {
        return NotificationCompat.Action(
            R.drawable.media_session_service_notification_ic_skip_to_next,
            "next",
            MediaButtonReceiver.buildMediaButtonPendingIntent(
                context,
                PlaybackStateCompat.ACTION_SKIP_TO_NEXT
            )
        )
    }
}