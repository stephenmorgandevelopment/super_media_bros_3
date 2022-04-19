

import 'package:flutter/services.dart';
import 'package:super_media_bros_3/platform/media_message_codec.dart';

class PlayerController {
  static const String AUDIO_PLAYER_CHANNEL =
      'com.stephenmorgandevelopment.super_media_bros_3/audio_player';

  static MethodChannel channel = const MethodChannel(
    AUDIO_PLAYER_CHANNEL,
    StandardMethodCodec(MediaMessageCodec())
  )..setMethodCallHandler(callHandler);


  static Future<dynamic> callHandler(MethodCall call) async {
    switch(call.method) {
      case "updateInfo":


        break;
      case "setPlayerState":

        break;
    }
  }

  static Future<void> setPlayerState(int state) async {
    // TODO change player state and ui accordingly.
  }

  static Future<void> updateInfo(String infoTag, dynamic info) async {
    switch (infoTag) {

    }
  }

}

