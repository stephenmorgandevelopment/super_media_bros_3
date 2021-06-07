

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/models/media_resource.dart';
import 'package:super_media_bros_3/repo/image_repo.dart';

class ImageScreenBloc extends MediaBloc {
  @override
  List<MediaData> mediaList;
  final ImageRepo repo;

  int? _currentIndex;
  MediaResource? _currentImage;
  MediaResource? get currentImage => _currentImage;

  ImageScreenBloc(this.mediaList, {this.repo = const ImageRepo()})
      : super(mediaList, Type.IMAGE);

  Future<Uint8List?> getThumbnail(int index) async {
    return await repo.getThumbnailBytes(mediaList[index]);
  }

  Future<MediaResource> getMedia(int index) async {
    _currentIndex = index;

    Uint8List? bytes = await repo.getBytes(mediaList[index]);
    if(bytes != null) {
      log("ImageScreenBloc-ln33: Made with ${bytes.lengthInBytes} bytes.");
      return MediaResource.withBytes(mediaList[index], bytes);
    }

    // return MediaResource(mediaList[index], null, null);
    return Future.error("Unexpected IO error, check permissions.");

    // MediaResource image;
    // try {
    //
    // } catch(e) {
    //   log("ImageScreenBloc-ln31: Null Bytes and Null File passed to ImageResource.");
    // }
  }







}