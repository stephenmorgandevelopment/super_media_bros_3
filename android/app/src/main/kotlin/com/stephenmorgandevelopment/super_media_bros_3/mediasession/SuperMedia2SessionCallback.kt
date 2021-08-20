package com.stephenmorgandevelopment.super_media_bros_3.mediasession

import android.net.Uri
import android.os.Bundle
import android.os.Process
import android.provider.MediaStore
import androidx.core.app.BundleCompat
import androidx.media2.common.*
import androidx.media2.common.MediaMetadata.*
import androidx.media2.session.*
import androidx.media2.session.SessionCommand.*
import com.stephenmorgandevelopment.super_media_bros_3.MediaRepo
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.AudioAccess
import com.stephenmorgandevelopment.super_media_bros_3.mediasession.SuperMediaSessionService.*
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.ColumnAll
import com.stephenmorgandevelopment.super_media_bros_3.mediastore.ColumnAll.*
import com.stephenmorgandevelopment.super_media_bros_3.models.Media
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaQuery
import com.stephenmorgandevelopment.super_media_bros_3.models.UserLikeRating

class SuperMedia2SessionCallback : MediaSession.SessionCallback(), ColumnAll {
    private val SUPER_UUID = Process.getGidForName(SUPER_MEDIA_BROS_PACKAGE)
    private val MY_UUID = Process.myUid()
//    private var audioAccess: AudioAccess = AudioAccess(Provider.provideContentResolver())
    private val repo: MediaRepo = Provider.provideRepo()

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
            return verifyCommandSupported(command)
        } else if(requestApproval(controller.packageName)) {
            return verifyCommandSupported(command)
        }

        return SessionResult.RESULT_ERROR_PERMISSION_DENIED
    }

    override fun onCreateMediaItem(
        session: MediaSession,
        controller: MediaSession.ControllerInfo,
        mediaId: String
    ): MediaItem? {
        val media = repo.getMediaById(mediaId)
        val mediaMetadata = media?.let {
            makeMetadataFromMedia(it)
        }

        return if(mediaMetadata != null) {
            MediaItem.Builder().setMetadata(mediaMetadata).build()
        } else {
            //Assume that it isn't an audio track, but a list of media.
            val metadata = makeMetadataFromBrowseable(mediaId)

            MediaItem.Builder().setMetadata(metadata).build()
        }
    }

    override fun onSetMediaUri(
        session: MediaSession,
        controller: MediaSession.ControllerInfo,
        uri: Uri,
        extras: Bundle?
    ): Int {
        val media = repo.getMediaByUri(uri)
        if(media != null) {
            val item =
                MediaItem.Builder().setMetadata(makeMetadataFromMedia(media)).build()

            session.player.setMediaItem(item)
            session.player.prepare()

            return SessionResult.RESULT_SUCCESS
        }


        return SessionResult.RESULT_ERROR_UNKNOWN
    }

    override fun onSkipForward(
        session: MediaSession,
        controller: MediaSession.ControllerInfo
    ): Int {
        return super.onSkipForward(session, controller)
    }

    override fun onSkipBackward(
        session: MediaSession,
        controller: MediaSession.ControllerInfo
    ): Int {
        return super.onSkipBackward(session, controller)
    }

    override fun onSetRating(
        session: MediaSession,
        controller: MediaSession.ControllerInfo,
        mediaId: String,
        rating: Rating
    ): Int {
        return super.onSetRating(session, controller, mediaId, rating)
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

    private fun verifyCommandSupported(command : SessionCommand) =
        if(supportedCommands.hasCommand(command)) {
            SessionResult.RESULT_SUCCESS
        } else {
            SessionResult.RESULT_ERROR_NOT_SUPPORTED
        }


    fun requestApproval(packageName: String) : Boolean {
        // TODO Request approval and ask user if they want to save their choice.


        return isApproved(packageName)
    }

    fun isApproved(packageName: String) : Boolean {
        // TODO Devise means to check if user approves of these apps having access.  Add an option
        // TODO list approved packages in Settings menu.

        return false
    }







    //TODO Needed because Android has SERIOUS versioning issues.
    //TODO Example:  All these werer available to me under MediaColumns on the first version
    //TODO of SMB.  Targeting sdk 28 down to sdk 21

    //TODONE Made the interface ColumnAll......took like 30 seconds with copy and paste.

    //TODO Stop spending time trying to figure out why Google sucks and just make a quick
    //TODO workaround...but not really.  I still don't know what's up with this.  I want to know tho.

    //TODO For whatever reason...android thinks that these arn't available until sdk 30.
    //TODO Why??  IDK, spent an hour or so trying to figure it out, but making these.
    //TODO INCLUDING TODO'S took about 3 minutes.

    fun makeMetadataFromMedia(media: Media) : MediaMetadata {
        val data = media.metadata
        val audioDescription = "${data[ARTIST]}: ${data[ALBUM]}-${data[CD_TRACK_NUMBER]}"

        val builder = Builder()
            .putString(METADATA_KEY_MEDIA_URI, media.uri.toString())
            .putString(METADATA_KEY_MEDIA_ID, data[_ID])
            .putString(METADATA_KEY_DISPLAY_TITLE, data[DISPLAY_NAME])
            .putString(METADATA_KEY_DISPLAY_DESCRIPTION, audioDescription)
            .putString(METADATA_KEY_ARTIST, data[DISPLAY_NAME])
            .putString(METADATA_KEY_ALBUM, data[DISPLAY_NAME])
            .putString(METADATA_KEY_ALBUM_ARTIST, data[DISPLAY_NAME])
            .putLong(METADATA_KEY_TRACK_NUMBER, data[CD_TRACK_NUMBER]!!.toLong())
            .putRating(METADATA_KEY_USER_RATING, UserLikeRating(data[IS_FAVORITE].toBoolean()))
            .putLong(METADATA_KEY_PLAYABLE, 1)
            .putBitmap(METADATA_KEY_ALBUM_ART, repo.getThumbBitmap(media))
            .putLong(METADATA_KEY_DURATION, data[DURATION]!!.toLong())

        val extras = Bundle().apply {
            putString(IS_AUDIOBOOK, data[IS_AUDIOBOOK])
            putString(IS_MUSIC, data[IS_MUSIC])
            putString(IS_PODCAST, data[IS_PODCAST])
        }

        return builder.build()
    }

    fun makeMetadataFromBrowseable(id: String) : MediaMetadata {
        // TODO Write implementation
        return Builder().build()
    }
}