import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
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
      log("MediaAccess-dart: line 27");
      log(e.toString());
    }
    return null;
  }

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

  static Future<List<MediaData>> getAllData(Type mediaType) async {
    List<MediaData>? results;
    if (mediaType == null) {}
    try {
      results = Platform.isAndroid
          ? await MediaAccess.channel.invokeListMethod<MediaData>(
              'getAllData',
              {'type': mediaType},
            )
          : await iOSandWebPlaceholder();
    } catch (e) {
      log("MediaAccess-dart: line 58");
      log(e.toString());
    }

    return results ?? <MediaData>[];
  }

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
      log("ImageAccess-dart: line 56");
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
      log("MediaAccess-dart: line 71");
      log(e.toString());
    }
    return thumbnail;
  }

  static Future<List<MediaData>> iOSandWebPlaceholder() async => <MediaData>[];
}
