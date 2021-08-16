package com.stephenmorgandevelopment.super_media_bros_3.mediasession

import android.os.Process
import android.provider.MediaStore
import androidx.media2.common.MediaItem
import androidx.media2.common.MediaMetadata
import androidx.media2.session.*
import androidx.media2.session.SessionCommand.*
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.AudioAccess
import com.stephenmorgandevelopment.super_media_bros_3.mediasession.SuperMediaSessionService.*
import com.stephenmorgandevelopment.super_media_bros_3.models.Media
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaQuery

class SuperMedia2SessionCallback : MediaSession.SessionCallback() {
    private val SUPER_UUID = Process.getGidForName(SUPER_MEDIA_BROS_PACKAGE)
    private val MY_UUID = Process.myUid()
    private var audioAccess: AudioAccess? = null

    private val supportedCommands =SessionCommandGroup.Builder()
        .addCommand(SessionCommand(COMMAND_CODE_PLAYER_PLAY))
        .addCommand(SessionCommand(COMMAND_CODE_PLAYER_PAUSE))
        .addCommand(SessionCommand(COMMAND_CODE_PLAYER_SEEK_TO))
        .addCommand(SessionCommand(COMMAND_CODE_PLAYER_SKIP_TO_NEXT_PLAYLIST_ITEM))
        .addCommand(SessionCommand(COMMAND_CODE_PLAYER_SKIP_TO_PREVIOUS_PLAYLIST_ITEM))
        .addCommand(SessionCommand(COMMAND_CODE_PLAYER_PREPARE))
        .build()

    override fun onCommandRequest(
        session: MediaSession,
        controller: MediaSession.ControllerInfo,
        command: SessionCommand
    ): Int {
        if(controller.packageName == SUPER_MEDIA_BROS_PACKAGE || isApproved(controller.packageName)) {
            return SessionResult.RESULT_SUCCESS
        } else if(requestApproval(controller.packageName)) {
            return SessionResult.RESULT_SUCCESS
        }

        return SessionResult.RESULT_ERROR_PERMISSION_DENIED
    }

    override fun onCreateMediaItem(
        session: MediaSession,
        controller: MediaSession.ControllerInfo,
        mediaId: String
    ): MediaItem? {
        if(audioAccess == null) {
            audioAccess = AudioAccess(Provider.provideContentResolver())
        }

        val data: Media = audioAccess!!.query(
            MediaQuery.Assemble.audioTrackDataForPlayerById(mediaId))[0]

        val mediaMetadata = makeMetadataFromMedia(data)

        return MediaItem.Builder()
            .setMetadata(mediaMetadata)
            .build()
    }

    fun makeMetadataFromMedia(data: Media) : MediaMetadata {
        // TODO Create metadata object from metadata pulled from the MediaStore.
        return MediaMetadata.Builder()
            // TODO Make a helper class for columns to cut down clutter and make typing these easier.
            .putString(MediaStore.MediaColumns.DISPLAY_NAME, data.metadata[MediaStore.MediaColumns.DISPLAY_NAME])
            .build()

    }

    override fun onConnect(
        session: MediaSession,
        controller: MediaSession.ControllerInfo
    ): SessionCommandGroup? {
        val uidMatches =
            (controller.uid == SUPER_UUID || controller.uid == MY_UUID)

        if(controller.packageName == SUPER_MEDIA_BROS_PACKAGE && uidMatches) {
            return supportedCommands
        }

        return null
    }

    override fun onDisconnected(session: MediaSession, controller: MediaSession.ControllerInfo) {
        super.onDisconnected(session, controller)
    }

    fun requestApproval(packageName: String) : Boolean {
        // TODO Request approval and ask user if they want to save their choice.


        return isApproved(packageName)
    }

    fun isApproved(packageName: String) : Boolean {
        // TODO Devise means to check if user approves of these apps having access.  Add an  option
        // TODO list approved packages in Settings menu.

        return false
    }
}