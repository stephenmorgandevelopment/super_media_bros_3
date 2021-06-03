import 'dart:async';
import 'dart:developer';

import 'dart:io';

import 'package:super_media_bros_3/data/media_interface.dart';
import 'package:super_media_bros_3/models/media.dart';

class ImageAccess extends MediaAccess {
  static Future<List<Media>> getAllImagesData() async {
    List<Media>? results;
    try {
      results = Platform.isAndroid
          ? await MediaAccess.channel.invokeListMethod<Media>('getAllImagesData')
          : await nothing();
    } catch (e) {
      log(e.toString());
    }

    return results ?? <Image>[];
  }

  static Future<List<Image>> getAllImagesPathData() async {
    List<Image>? results;
    try {
      results = Platform.isAndroid
          ? await MediaAccess.channel.invokeListMethod<Image>('getAllImagesPathData')
          : await nothing();
    } catch (e) {
      log(e.toString());
    }

    return results ?? <Image>[];
  }

  static Future<List<dynamic>> getAllImagesThumbnails() async {
    List<dynamic>? results;
    try {
      results = Platform.isAndroid
          ? await MediaAccess.channel.invokeListMethod('getAllImagesThumbnails')
          : await nothing();
    } catch (e) {
      log(e.toString());
    }

    return results ?? <Media>[];
  }

  static Future<List<Image>> nothing() async => <Image>[];
}
