import 'dart:async';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/platform/media_message_codec.dart';

abstract class MediaAccess {
  static bool _hasReadPermission = false;
  static bool get hasReadPermission => _hasReadPermission;
  static const String MEDIA_DATA_CHANNEL =
      'com.stephenmorgandevelopment.super_media_bros_3/media_data';

  static MethodChannel channel = const MethodChannel(
    MEDIA_DATA_CHANNEL,
    StandardMethodCodec(MediaMessageCodec()),
  );

  static Future<List<MediaData>> getData() async {

    return <MediaData>[];
  }

  static Future<void> requestPermission() async {
    var status = await Permission.storage.status;
    if(status.isGranted) {
      _hasReadPermission = true;
    } else if(await Permission.storage.request().isGranted) {
      _hasReadPermission = true;
    } else {
      status = await Permission.storage.status;

      if(status.isDenied || status.isPermanentlyDenied) {
        _hasReadPermission = false;
      }
    }
  }
}