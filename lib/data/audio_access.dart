import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:super_media_bros_3/data/media_interface.dart';
import 'package:super_media_bros_3/models/media_data.dart';

class AudioAccess extends MediaAccess {
  static Future<List<MediaData>> getAllData() async {
    List<MediaData>? results;
    try {
      results = Platform.isAndroid
          ? await MediaAccess.channel.invokeListMethod<MediaData>('getAllAudioData')
          : await nothing();
    } catch (e) {
      log("AudioAccess-dart: line 17");
      log(e.toString());
    }

    return results ?? <MediaData>[];
  }

  static Future<Uint8List?> getThumbnail(MediaData media) async {
    Uint8List? thumbnail;
    try {
      thumbnail = await MediaAccess.channel.invokeMethod<Uint8List>(
          'getAlbumArtwork',
          {'audio': media});
    } catch(e) {
      log("AudioAccess-dart: line 31");
      log(e.toString());
    }
    return thumbnail;
  }

  static Future<List<MediaData>> nothing() async => <MediaData>[];
}