package com.stephenmorgandevelopment.super_media_bros_3

import android.content.Context
import android.net.Uri
import android.os.Bundle
import androidx.media2.common.MediaItem
import androidx.media2.common.MediaMetadata
import androidx.media2.common.SessionPlayer
import androidx.media2.common.SubtitleData
import androidx.media2.player.MediaPlayer
import androidx.media2.session.*
import com.stephenmorgandevelopment.super_media_bros_3.mediasession.PlayerThreads
import com.stephenmorgandevelopment.super_media_bros_3.models.AudioPlayerState


//class SuperMediaPlayer(private val context: Context) {
class SuperMediaPlayer(context: Context, private val token: SessionToken) {

    private val superMediaControllerCallback = SuperMediaControllerCallback()

    val controller: MediaController = MediaController.Builder(context)
        .setControllerCallback(PlayerThreads.callbackThread, superMediaControllerCallback)
        .setSessionToken(token)
        .build()

    object State {
        private var snapshot: AudioPlayerState? = null
        fun current() = snapshot

        fun update(state: AudioPlayerState) {
            snapshot = state
        }
    }
}

private fun sendState(state: Int) {
    MainActivity.Channels.player.invokeMethod("setPlayerState", state)
}

private fun sendPlaybackSpeed(speed: Float) {
    MainActivity.Channels.player.invokeMethod(
        "updateInfo",
        listOf<Any>("player_speed", speed))
}

class SuperMediaControllerCallback : MediaController.ControllerCallback() {
    override fun onPlayerStateChanged(controller: MediaController, state: Int) {
        sendState(state)
    }

    override fun onConnected(controller: MediaController, allowedCommands: SessionCommandGroup) {
        sendState(SessionPlayer.PLAYER_STATE_IDLE)
    }

    override fun onPlaybackInfoChanged(
        controller: MediaController,
        info: MediaController.PlaybackInfo
    ) {
        // TODO Seems like something should go here, but I can't infer what yet.


    }

    override fun onDisconnected(controller: MediaController) {

        controller.close()
    }

    override fun onPlaybackSpeedChanged(controller: MediaController, speed: Float) {
        sendPlaybackSpeed(speed)
    }

    override fun onBufferingStateChanged(controller: MediaController, item: MediaItem, state: Int) {
        super.onBufferingStateChanged(controller, item, state)
    }

    override fun onSeekCompleted(controller: MediaController, position: Long) {
        super.onSeekCompleted(controller, position)
    }

    override fun onCurrentMediaItemChanged(controller: MediaController, item: MediaItem?) {
        val metadata = item?.metadata ?: return
        val mediaUri = metadata.getString(MediaMetadata.METADATA_KEY_MEDIA_URI)!!

        when (controller.playerState) {


        }

    }

    override fun onPlaylistChanged(
        controller: MediaController,
        list: MutableList<MediaItem>?,
        metadata: MediaMetadata?
    ) {
        super.onPlaylistChanged(controller, list, metadata)
    }

    override fun onPlaylistMetadataChanged(controller: MediaController, metadata: MediaMetadata?) {
        super.onPlaylistMetadataChanged(controller, metadata)
    }

    override fun onShuffleModeChanged(controller: MediaController, shuffleMode: Int) {
        super.onShuffleModeChanged(controller, shuffleMode)
    }

    override fun onRepeatModeChanged(controller: MediaController, repeatMode: Int) {
        super.onRepeatModeChanged(controller, repeatMode)
    }

    override fun onPlaybackCompleted(controller: MediaController) {
        super.onPlaybackCompleted(controller)
    }

//    override fun onVideoSizeChanged(
//        controller: MediaController,
//        item: MediaItem,
//        videoSize: VideoSize
//    ) {
//        super.onVideoSizeChanged(controller, item, videoSize)
//    }

//    override fun onVideoSizeChanged(controller: MediaController, videoSize: VideoSize) {
//        super.onVideoSizeChanged(controller, videoSize)
//    }

    override fun onTracksChanged(
        controller: MediaController,
        tracks: MutableList<SessionPlayer.TrackInfo>
    ) {
        super.onTracksChanged(controller, tracks)
    }

    override fun onTrackSelected(controller: MediaController, trackInfo: SessionPlayer.TrackInfo) {
        super.onTrackSelected(controller, trackInfo)
    }

    override fun onTrackDeselected(
        controller: MediaController,
        trackInfo: SessionPlayer.TrackInfo
    ) {
        super.onTrackDeselected(controller, trackInfo)
    }

    override fun onSubtitleData(
        controller: MediaController,
        item: MediaItem,
        track: SessionPlayer.TrackInfo,
        data: SubtitleData
    ) {
        super.onSubtitleData(controller, item, track, data)
    }

    override fun onSetCustomLayout(
        controller: MediaController,
        layout: MutableList<MediaSession.CommandButton>
    ): Int {
        return super.onSetCustomLayout(controller, layout)
    }

    override fun onAllowedCommandsChanged(
        controller: MediaController,
        commands: SessionCommandGroup
    ) {
        super.onAllowedCommandsChanged(controller, commands)
    }

    override fun onCustomCommand(
        controller: MediaController,
        command: SessionCommand,
        args: Bundle?
    ): SessionResult {
        return super.onCustomCommand(controller, command, args)
    }
}