package com.stephenmorgandevelopment.super_media_bros_3.mediasession

import android.app.Notification
import android.graphics.Color
import android.media.MediaSession2Service
import android.os.Bundle
import android.support.v4.media.MediaBrowserCompat
import android.support.v4.media.MediaDescriptionCompat
import android.support.v4.media.MediaMetadataCompat
import android.support.v4.media.session.MediaSessionCompat
import android.support.v4.media.session.PlaybackStateCompat
import android.support.v4.media.session.PlaybackStateCompat.*
import androidx.core.app.NotificationCompat
import androidx.media.MediaBrowserServiceCompat
import androidx.media.app.NotificationCompat.MediaStyle
import androidx.media.session.MediaButtonReceiver
import androidx.media2.session.MediaSession
import androidx.media2.session.MediaSessionService
import com.stephenmorgandevelopment.super_media_bros_3.R
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.AudioAccess
import com.stephenmorgandevelopment.super_media_bros_3.models.Audio
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaGroup
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaGroups
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaQuery
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob

private const val TAG = "AudioPlayerService";
//private const val SUPER_MEDIA_BROS_PACKAGE = "com.stephenmorgandevelopment.super_media_bros_3"
private const val FULL_ACCESS_MEDIA_ROOT_ID = "__ROOT__"
private const val LIMITED_ACCESS_MEDIA_ROOT_ID = "__LIMITED__"

private const val NOTIFICATION_CHANNEL = "super_media_bros_3_audio_player"


// TODO Use this for pre android 29 playback.  After 29+ impl is finished.
class AudioPlayerService : MediaBrowserServiceCompat() {
    private lateinit var audioAccess: AudioAccess
    private lateinit var mediaList: List<Audio>
    private lateinit var groups: List<MediaGroup>
    private lateinit var notification: Notification

    private val serviceJob = SupervisorJob()
    private val serviceScope = CoroutineScope(Dispatchers.Main + serviceJob)

    var mediaSession: MediaSessionCompat? = null
        private set
    private lateinit var stateBuilder: PlaybackStateCompat.Builder

    override fun onCreate() {
        super.onCreate()

        val callback = SuperMediaSessionCallback(baseContext, this)
        mediaSession = MediaSessionCompat(baseContext, TAG).apply {
//            setFlags(MediaSessionCompat.FLAG_HANDLES_QUEUE_COMMANDS)

            stateBuilder = Builder().setActions(
                ACTION_PLAY or ACTION_PAUSE or ACTION_SEEK_TO or ACTION_SKIP_TO_NEXT
                        or ACTION_SKIP_TO_PREVIOUS or ACTION_SET_REPEAT_MODE or ACTION_STOP)

            setPlaybackState(stateBuilder.build())

            setCallback(callback)

            setSessionToken(sessionToken)
        }

    }

    override fun onGetRoot(
        clientPackageName: String,
        clientUid: Int,
        rootHints: Bundle?
    ): BrowserRoot? {
        return if (clientPackageName == SUPER_MEDIA_BROS_PACKAGE) {
            BrowserRoot(FULL_ACCESS_MEDIA_ROOT_ID, null)
        } else {
            // TODO Provide access level specified by user in options.
            BrowserRoot(LIMITED_ACCESS_MEDIA_ROOT_ID, null)
        }
    }

    override fun onLoadChildren(
        parentId: String,
        result: Result<MutableList<MediaBrowserCompat.MediaItem>>
    ) {
        if (parentId == LIMITED_ACCESS_MEDIA_ROOT_ID) {
            // TODO("Provided specified access to media.")
            return
        }

        val mediaItems = mutableListOf<MediaBrowserCompat.MediaItem>()
        if (parentId == FULL_ACCESS_MEDIA_ROOT_ID) {
            for (group in groups) {
                val description = makeDescription(group)

                mediaItems.add(
                    MediaBrowserCompat.MediaItem(
                        description,
                        MediaBrowserCompat.MediaItem.FLAG_PLAYABLE
                    )
                )
            }
        } else {
            // TODO Check parentId and load accordingly.

        }
    }

    private fun makeDescription(group: MediaGroup) : MediaDescriptionCompat =
        MediaDescriptionCompat.Builder()
            .setTitle(group.name)
            .setIconBitmap(audioAccess.genBitmapThumbnail(group.mediaList[0]))
            .setMediaUri(group.mediaList[0].uri)
            .build()


    fun initMediaData() {
        audioAccess = AudioAccess(contentResolver)
        mediaList = audioAccess.query(MediaQuery.Assemble.allAlbums())
        groups = MediaGroups.genGroupsFromList(mediaList)
    }

    private fun prepNotification(description: MediaDescriptionCompat) : NotificationCompat.Builder {
        return NotificationCompat.Builder(baseContext, NOTIFICATION_CHANNEL).apply {
            setContentTitle(description.title)
            setContentText(description.subtitle)
            setSubText(description.description)
            setLargeIcon(description.iconBitmap)

            setContentIntent(mediaSession!!.controller.sessionActivity)
            setDeleteIntent(
                MediaButtonReceiver.buildMediaButtonPendingIntent(
                    baseContext,
                    ACTION_STOP)
            )

            setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            setSmallIcon(R.mipmap.ic_launcher_foreground)
            color = Color.argb(195,155,155,155)

            addAction(NotificationActions.prevTrack(baseContext))
            addAction(NotificationActions.playPause(baseContext))
            addAction(NotificationActions.nextTrack(baseContext))

            setStyle(
                MediaStyle()
                    .setMediaSession(mediaSession?.sessionToken)
                    .setShowActionsInCompactView(0,1,2))
        }
    }

    fun updateNotification(description: MediaDescriptionCompat) {
//        val tmp = NotificationCompat.Builder(baseContext, notification)
    }

}


