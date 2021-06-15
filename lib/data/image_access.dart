import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:super_media_bros_3/data/media_interface.dart';
import 'package:super_media_bros_3/models/media_data.dart';

class ImageAccess extends MediaAccess {
  // static Future<List<MediaData>> getAllData() async {
  //   List<MediaData>? results;
  //   try {
  //     results = Platform.isAndroid
  //         ? await MediaAccess.channel.invokeListMethod<MediaData>('getAllImagesData')
  //         : await nothing();
  //   } catch (e) {
  //     log("ImageAccess-dart: line 18");
  //     log(e.toString());
  //   }
  //
  //   return results ?? <ImageData>[];
  // }

  static Future<List<MediaData>> getAllImagesPathData() async {
    List<MediaData>? results;
    try {
      results = Platform.isAndroid
          ? await MediaAccess.channel
              .invokeListMethod<MediaData>('getAllImagesPathData')
          : await MediaAccess.iOSandWebPlaceholder();
    } catch (e) {
      log("ImageAccess-dart: line 32");
      log(e.toString());
    }

    return results ?? <ImageData>[];
  }

  // static Future<MediaData?>? getData(MediaData media) {
  //   try {
  //     return MediaAccess.channel.invokeMethod<MediaData>('getData', {'media': media});
  //   } catch(e) {
  //     log("ImageAccess-dart: line 43");
  //     log(e.toString());
  //   }
  //   return null;
  // }

  // static Future<Uint8List?> getImageAsBytes(MediaData media) async {
  //   Uint8List? imageBytes;
  //   try {
  //     imageBytes = await MediaAccess.channel
  //         .invokeMethod<Uint8List>('getImage', {'image': media});
  //   } catch (e) {
  //     log("ImageAccess-dart: line 56");
  //     log(e.toString());
  //   }
  //   return imageBytes;
  // }

  // static Future<Uint8List?> getThumbnail(MediaData image) async {
  //   Uint8List? thumbnail;
  //   try {
  //     thumbnail = await MediaAccess.channel.invokeMethod<Uint8List>(
  //           'getImageThumbnail',
  //           {'image': image});
  //   } catch(e) {
  //     log("ImageAccess-dart: line 69");
  //     log(e.toString());
  //   }
  //   return thumbnail;//?? Uint8List(0);
  // }

  // static Future<List<Uint8List>> getAllImageThumbnails() async {
  //   List<Uint8List>? results;
  //   try {
  //     results =  await MediaAccess.channel.invokeListMethod<Uint8List>('getAllImageThumbnails');
  //   } catch (e) {
  //     log("ImageAccess-dart: line 80");
  //     log(e.toString());
  //   }
  //
  //   return results ?? <Uint8List>[];
  // }
  //
  // static Future<List<ImageData>> nothing() async => <ImageData>[];
}
