package com.stephenmorgandevelopment.super_media_bros_3.method_channel_utils

import com.stephenmorgandevelopment.super_media_bros_3.SuperMediaPlayer
import com.stephenmorgandevelopment.super_media_bros_3.models.Media
import com.stephenmorgandevelopment.super_media_bros_3.models.MediaGroup
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class SuperMediaControllerCallHandler :  MethodChannel.MethodCallHandler {
    private var superMediaPlayer: SuperMediaPlayer? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method) {
            "pollPlayer" -> pollPlayer(result)
            "getPlaylist" -> getPlaylist(result)

            "playMedia" -> playMedia(result, call.argument<Media>("media"))
            "playList" -> playList(result, call.argument<List<Media>>("mediaList"))
            "playGroup" -> playGroup(result, call.argument<MediaGroup>("mediaGroup"))

            "resumePlay" -> resumePlay(result)
            "pause" -> pause(result)
            "seekTo" -> seekTo(result, call.argument<Long>("position"))
            "skipNext" -> skipNext(result)
            "skipPrev" -> skipPrev(result)

            "preparePlayer" -> preparePlayer(result)

            else -> result.error(
                "No such method",
                "No method was found matching this name: ${call.method}",
                null)
        }
    }

    private fun pollPlayer(result: MethodChannel.Result) {}

    private fun getPlaylist(result: MethodChannel.Result) {}

    private fun playMedia(result: MethodChannel.Result, media: Media?) {}
    private fun playList(result: MethodChannel.Result, mediaList: List<Media>?) {}

    private fun playGroup(result: MethodChannel.Result, mediaGroup: MediaGroup?) {}

    private fun resumePlay(result: MethodChannel.Result) {}
    private fun pause(result: MethodChannel.Result){}
    private fun seekTo(result: MethodChannel.Result, position: Long?) {}
    private fun skipNext(result: MethodChannel.Result) {}
    private fun skipPrev(result: MethodChannel.Result) {}
    private fun preparePlayer(result: MethodChannel.Result) {}

}