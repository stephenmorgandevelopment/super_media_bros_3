package com.stephenmorgandevelopment.super_media_bros_3.mediasession

import android.app.Notification
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioManager
import android.media.MediaPlayer
import android.support.v4.media.session.MediaSessionCompat
import androidx.media.AudioAttributesCompat
import androidx.media.AudioFocusRequestCompat
import androidx.media.AudioManagerCompat


// TODO Use this with MediaBrowserCompat for pre android 29 playback.  After 29+ impl is finished.
class SuperMediaSessionCallback(
    private val context: Context,
    private val service: AudioPlayerService
) : MediaSessionCompat.Callback() {

    private val intentFilter = IntentFilter(AudioManager.ACTION_AUDIO_BECOMING_NOISY)
    private val noisyAudioStreamReceiver = BecomingNoisyReceiver(this)

    private lateinit var focusChangeListener: AudioManager.OnAudioFocusChangeListener
    lateinit var playerNotification: Notification
    var player: MediaPlayer = MediaPlayer()

    private lateinit var audioFocusRequest: AudioFocusRequestCompat

    private var id = -1

    init {
        player
    }

    override fun onPlay() {
        val am = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager

        audioFocusRequest = AudioFocusRequestCompat.Builder(AudioManagerCompat.AUDIOFOCUS_GAIN).run {
            setOnAudioFocusChangeListener(focusChangeListener)
            setAudioAttributes(AudioAttributesCompat.Builder().run {
                setContentType(AudioAttributesCompat.CONTENT_TYPE_MUSIC)
                build()
            })

            build()
        }

        val result = AudioManagerCompat.requestAudioFocus(am, audioFocusRequest)
        if(result == AudioManager.AUDIOFOCUS_REQUEST_GRANTED) {
            service.startService(Intent(context, AudioPlayerService::class.java))
            service.mediaSession?.isActive = true
//            player.start()
            service.registerReceiver(noisyAudioStreamReceiver, intentFilter)
            service.startForeground(id, playerNotification)
        }
    }

    override fun onPause() {
        val am = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager

        //player.pause()
        service.unregisterReceiver(noisyAudioStreamReceiver)
        service.stopForeground(false)
    }

    override fun onStop() {
        val am = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager

        AudioManagerCompat.abandonAudioFocusRequest(am, audioFocusRequest)
        service.unregisterReceiver(noisyAudioStreamReceiver)
        service.stopSelf()
        service.mediaSession?.isActive = false
        //player.stop()
        service.stopForeground(false)
    }

    override fun onSkipToNext() {

    }

    override fun onSkipToPrevious() {

    }

    override fun onSeekTo(pos: Long) {

    }
}

class BecomingNoisyReceiver(private val callback: SuperMediaSessionCallback) : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == AudioManager.ACTION_AUDIO_BECOMING_NOISY) {
            callback.onPause()
        }
    }
}