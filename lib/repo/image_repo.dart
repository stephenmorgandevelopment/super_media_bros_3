

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:super_media_bros_3/data/image_access.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/repo/media_repo.dart';


class ImageRepo extends MediaRepo {

  const ImageRepo();

  Future<Uint8List?> getBytes(MediaData image) async {
    if(image.isLocal()) {
      return getLocalImageBytes(image);
    } else {

    }
  }

  Future<Uint8List?> getThumbnailBytes(MediaData image) async {
    return getLocalThumbnailBytes(image);
  }

  Future<Uint8List?> getLocalThumbnailBytes(MediaData image) async {
    return ImageAccess.getImageThumbnail(image);
  }

  Future<Uint8List?> getLocalImageBytes(MediaData image) async {
    return await ImageAccess.getImageAsBytes(image);
  }

  File? getLocalImageFile(MediaData image) {
    String? filePath = image.metadata['_data'];
    String? relativePath = image.metadata['relative_path'];

    File? imageFile;
    if (filePath != null) {
      imageFile = File(filePath);
    } else if (relativePath != null) {
      log("Used relative path for ${image.metadata}");
      imageFile = File(relativePath);
    }
    return imageFile;
  }
}