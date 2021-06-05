import 'dart:async';
import 'dart:developer';

import 'dart:io';
import 'dart:typed_data';

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
      log("ImageAccess-dart: line 18");
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
      log("ImageAccess-dart: line 31");
      log(e.toString());
    }

    return results ?? <Image>[];
  }

  static Future<Media?>? getData(Media media) {
    try {
      return MediaAccess.channel.invokeMethod<Media>('getData', {'media': media});
    } catch(e) {
      log("ImageAccess-dart: line 43");
      log(e.toString());
    }
    return null;
  }

  static Future<Uint8List> getImageThumbnail(Image image) async {
    Uint8List? thumbnail;
    try {
      thumbnail = Platform.isAndroid
          ? await MediaAccess.channel.invokeMethod<Uint8List>(
            'getImageThumbnail',
            {'image': image})
          : null;
    } catch(e) {
      log("ImageAccess-dart: line 55");
      log(e.toString());
    }
    return thumbnail ?? Uint8List(0);
  }

  static Future<List<Uint8List>> getAllImageThumbnails() async {
    List<Uint8List>? results;
    try {
      results =  await MediaAccess.channel.invokeListMethod<Uint8List>('getAllImageThumbnails');
    } catch (e) {
      log("ImageAccess-dart: line 59");
      log(e.toString());
    }

    return results ?? <Uint8List>[];
  }

  static Future<List<Image>> nothing() async => <Image>[];
}
