import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:super_media_bros_3/data/media_interface.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/models/media_resource.dart';

class VideoAccess {//extends MediaAccess {
  // static Future<>
  // static Future<File?>> getFile() {
  //
  // }


  // static Future<List<MediaData>> getAllData(Type mediaType) async {
  //   List<MediaData>? results;
  //   try {
  //     results = Platform.isAndroid
  //         ? await MediaAccess.channel.invokeListMethod<MediaData>(
  //             'getAllData',
  //             {'type': mediaType})
  //         : await nothing();
  //   } catch (e) {
  //     log("MediaAccess-dart: line 17");
  //     log(e.toString());
  //   }
  //
  //   return results ?? <MediaData>[];
  // }
  //
  // static Future<Uint8List?> getThumbnail(MediaData media) async {
  //   Uint8List? thumbnail;
  //   try {
  //     thumbnail = await MediaAccess.channel.invokeMethod<Uint8List>(
  //         'getThumbnail',
  //         {'media': media});
  //   } catch(e) {
  //     log("MediaAccess-dart: line 31");
  //     log(e.toString());
  //   }
  //   return thumbnail;
  // }
  //
  // static Future<List<MediaData>> nothing() async => <MediaData>[];
}