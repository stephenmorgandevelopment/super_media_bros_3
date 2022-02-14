package com.stephenmorgandevelopment.super_media_bros_3

import androidx.annotation.NonNull
import com.stephenmorgandevelopment.super_media_bros_3.method_channel_utils.FlutterMediaMessageCodec
import com.stephenmorgandevelopment.super_media_bros_3.method_channel_utils.MediaMethodCallHandler
import com.stephenmorgandevelopment.super_media_bros_3.method_channel_utils.SuperMediaControllerCallHandler

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec

private const val MEDIA_DATA_CHANNEL
    = "com.stephenmorgandevelopment.super_media_bros_3/media_data"

const val AUDIO_PLAYER_CHANNEL
    = "com.stephenmorgandevelopment.super_media_bros_3/audio_player"

val featureSet = when (android.os.Build.VERSION.SDK_INT) {
    24,25 -> FeatureSet.BASIC
    in 26..28 -> FeatureSet.LIMITED
    in 29..100 -> FeatureSet.FULL
    else -> FeatureSet.UNSUPPORTED  // Google play should never actually allow this.........but when must be exhaustive............ :/
}

enum class FeatureSet {
    UNSUPPORTED, // Google play should never actually allow this.........but when must be exhaustive............ :/
    BASIC,
    LIMITED,
    FULL
}



class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val binaryMessager = flutterEngine.dartExecutor.binaryMessenger

        Channels.media = MethodChannel(
            binaryMessager,
            MEDIA_DATA_CHANNEL,
            StandardMethodCodec(FlutterMediaMessageCodec.INSTANCE)
        ).apply {
            setMethodCallHandler(MediaMethodCallHandler(contentResolver))
        }

        Channels.player = MethodChannel(
            binaryMessager,
            AUDIO_PLAYER_CHANNEL,
            StandardMethodCodec(FlutterMediaMessageCodec.INSTANCE)
        ).apply {
            setMethodCallHandler(SuperMediaControllerCallHandler())
        }
    }

    object Channels {
        lateinit var media: MethodChannel
        lateinit var player: MethodChannel
    }
}
