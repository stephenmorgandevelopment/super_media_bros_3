package com.stephenmorgandevelopment.super_media_bros_3.mediasession

// TODO Want to implement the new Media2 api, but lack of documentation is deterring me from using.

import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.os.Process
import android.provider.ContactsContract
import androidx.media.AudioAttributesCompat
import androidx.media.MediaBrowserServiceCompat
import androidx.media2.player.MediaPlayer
import androidx.media2.session.MediaSession
import androidx.media2.session.MediaSessionService
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import java.util.concurrent.Executors


private const val TAG = "AudioPlayerService";
const val SUPER_MEDIA_BROS_PACKAGE: String = "com.stephenmorgandevelopment.super_media_bros_3"
private val SUPER_UUID = Process.getGidForName(SUPER_MEDIA_BROS_PACKAGE)
private val MY_UUID = Process.myUid()
private const val PLAYBACK_REQUEST_FROM_TRANSPORT_PACKAGE = Intent.ACTION_MEDIA_BUTTON
private const val LEGACY_PLAYBACK_REQUEST_PACKAGE = MediaBrowserServiceCompat.SERVICE_INTERFACE


class SuperMediaSessionService : MediaSessionService() {
    private val serviceJob = SupervisorJob()
    private val serviceScope = CoroutineScope(Dispatchers.Main + serviceJob)

    private lateinit var callback: MediaSession.SessionCallback

    private val mediaPlayer: MediaPlayer = MediaPlayer(baseContext)
    private val mediaSession: MediaSession = MediaSession.Builder(baseContext, mediaPlayer)
        .apply {
            setSessionCallback(callbackExecutor, callback)
        }.build()

    val sessionToken get() = mediaSession.token

    private var audioAttributes: AudioAttributesCompat = AudioAttributesCompat.Builder()
        .setUsage(AudioAttributesCompat.USAGE_MEDIA)
        .setContentType(AudioAttributesCompat.CONTENT_TYPE_MUSIC)
        .build()

    var results = mediaPlayer.setAudioAttributes(audioAttributes)


    override fun onGetSession(controllerInfo: MediaSession.ControllerInfo): MediaSession? {
        Provider.init(applicationContext)

        val uidMatches =
            (controllerInfo.uid == SUPER_UUID || controllerInfo.uid == MY_UUID)

        return if (controllerInfo.packageName == SUPER_MEDIA_BROS_PACKAGE && uidMatches) {
            mediaSession
        } else {
            null
        }
    }

    private val callbackExecutor = Executors.newSingleThreadExecutor()


    private class Provide(val appContext: Context) {
        val contentResolver = appContext.contentResolver
    }

    object Provider {
        private lateinit var provide: Provide

        fun init(applicationContext: Context) {
            provide = Provide(applicationContext)
        }

        fun provideApplicationContext() = provide.appContext.applicationContext
        fun provideContentResolver() = provide.contentResolver
    }
}

