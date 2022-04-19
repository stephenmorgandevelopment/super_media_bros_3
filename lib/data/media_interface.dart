import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/platform/media_message_codec.dart';

abstract class MediaAccess {
  static bool _hasReadPermission = false;

  static bool get hasReadPermission {
    if (_hasReadPermission == true) {
      return true;
    }
    requestPermission();
    return false;
  }

  static const String MEDIA_DATA_CHANNEL =
      'com.stephenmorgandevelopment.super_media_bros_3/media_data';

  static MethodChannel channel = const MethodChannel(
    MEDIA_DATA_CHANNEL,
    StandardMethodCodec(MediaMessageCodec()),
  );

  static Future<MediaData?>? getData(MediaData media) {
    try {
      return MediaAccess.channel
          .invokeMethod<MediaData>('getData', {'media': media});
    } catch (e) {
      log("MediaAccess-dart: line 35");
      log(e.toString());
    }
    return null;
  }

  // TODO Create another message channel to serialize permission
  // TODO requests and responses to the system.  Then on the Android side,
  // TODO write a class to request permissions and respond.
  static Future<void> requestPermission() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      _hasReadPermission = true;
    } else if (await Permission.storage.request().isGranted) {
      _hasReadPermission = true;
    } else {
      status = await Permission.storage.status;

      if (status.isDenied || status.isPermanentlyDenied) {
        _hasReadPermission = false;
      }
    }
  }

  // TODO Convert to a smart Stream loader, that is aware of the scroll
  // TODO position of the grid/list view, and loads N pages to the stream
  // TODO in both directions.  Responding to user scroll or system changes.
  static Future<List<MediaData>> getAllData(Type mediaType) async {
    List<MediaData>? results;

    try {
      if(mediaType == Type.AUDIO) {
        results = await channel.invokeListMethod<MediaData>(
          'getAllAudioData',
          {'groupBy': MediaOptions.audioGroupBy}
        );
      } else {
        results = await MediaAccess.channel.invokeListMethod<MediaData>(
          'getAllData',
          {'type': mediaType},
        );
      }


    } catch (e) {
      log("MediaAccess-dart: line 73");
      log(e.toString());
    }

    return results ?? <MediaData>[];
  }

  // TODO Investigate the possibility of generating a byte stream, in Kotlin,
  // TODO on the Android side.  Then pipe that byte stream through a
  // TODO message/method channel.  If possible, then we could now build out
  // TODO the actual media players in Flutter Dart, rather than just sending
  // TODO Android a message telling it what to play and when we press buttons.
  // TODO (Which is all we are really doing at this point.)
  Future<Uint8List?> getMediaAsBytes(MediaData media) async {
    Uint8List? bytes;

    return bytes;
  }

  static Future<Uint8List?> getImageAsBytes(MediaData media) async {
    Uint8List? imageBytes;
    try {
      imageBytes = await MediaAccess.channel
          .invokeMethod<Uint8List>('getImage', {'image': media});
    } catch (e) {
      log("ImageAccess-dart: line 98");
      log(e.toString());
    }
    return imageBytes;
  }

  static Future<Uint8List?> getVideoAsBytes(MediaData media) async {
    Uint8List? bytes;

    return bytes;
  }

  static Future<Uint8List?> getAudioAsBytes(MediaData media) async {
    Uint8List? bytes;

    return bytes;
  }

  static Future<Uint8List?> getThumbnail(MediaData media) async {
    Uint8List? thumbnail;
    try {
      thumbnail = await MediaAccess.channel
          .invokeMethod<Uint8List>('getThumbnail', {'media': media});
    } catch (e) {
      log("MediaAccess-dart: line 122");
      log(e.toString());
    }
    return thumbnail;
  }

  static Future<List<MediaData>> iOSandWebPlaceholder() async => <MediaData>[];
}
