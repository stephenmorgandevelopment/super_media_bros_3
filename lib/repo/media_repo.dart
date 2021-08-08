import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:super_media_bros_3/data/media_interface.dart';
import 'package:super_media_bros_3/models/media_data.dart';

class MediaRepo {
  const MediaRepo();

  File? getLocalFile(MediaData media) {
    String? filePath = media.metadata['_data'];
    String? relativePath = media.metadata['relative_path'];

    File? mediaFile;
    if (filePath != null) {
      mediaFile = File(filePath);
    } else if (relativePath != null) {
      log("Used relative path for ${media.metadata}");
      mediaFile = File(relativePath);
    }
    return mediaFile;
  }

  Future<Uint8List?> getBytes(MediaData media) async {
    switch (media.type) {
      case Type.IMAGE:
        return await MediaAccess.getImageAsBytes(media);
      case Type.VIDEO:
        return await MediaAccess.getVideoAsBytes(media);
      case Type.AUDIO:
        return await MediaAccess.getAudioAsBytes(media);
    }
  }

  Future<Uint8List?> getThumbnailBytes(MediaData media) async {
    if (media.isLocal()) {
      return MediaAccess.getThumbnail(media);
    } else {
      //TODO Query and display internet media.
    }
  }
}
