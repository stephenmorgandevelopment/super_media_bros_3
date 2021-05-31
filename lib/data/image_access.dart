import 'dart:async';

import 'dart:io';

import 'package:super_media_bros_3/data/media_interface.dart';
import 'package:super_media_bros_3/models/media.dart';

class ImageAccess extends MediaAccess {

  static Future<List<Media>> getAllImagesData() async {
    List<Media>? results;
    try {
      results = Platform.isAndroid ?
        await MediaAccess.platform.invokeListMethod<Media>('getImages') :
        await nothing();
    } catch(e) {
      results = <Media>[];
    }

    return results ?? <Media>[];
  }

  static Future<List<Media>> nothing() async => await <Media>[];

}