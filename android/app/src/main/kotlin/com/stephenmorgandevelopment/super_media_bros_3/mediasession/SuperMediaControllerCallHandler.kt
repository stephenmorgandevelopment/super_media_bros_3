package com.stephenmorgandevelopment.super_media_bros_3.mediasession

import androidx.media2.session.MediaController
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class SuperMediaControllerCallHandler : MediaController(), MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        TODO("Not yet implemented")
    }
}