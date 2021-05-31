import 'dart:async';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:super_media_bros_3/models/media.dart';

abstract class MediaAccess {
  static bool _hasReadPermission = false;
  static bool get hasReadPermission => _hasReadPermission;
  static const String MEDIA_DATA_CHANNEL =
      'com.stephenmorgandevelopment.super_media_bros_3/media_data';

  static const platform = const MethodChannel(MEDIA_DATA_CHANNEL);

  static Future<List<Media>> getData() async {

    return <Media>[];
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

    // return false;
  }

}