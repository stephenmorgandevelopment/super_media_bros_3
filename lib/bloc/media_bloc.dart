import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:super_media_bros_3/data/media_interface.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/models/media_resource.dart';
import 'package:super_media_bros_3/repo/media_repo.dart';
import 'package:super_media_bros_3/widgets/needs_permission_text.dart';

class MediaBloc {
  @protected
  List<MediaData> mediaList;
  final Type? type;
  @protected
  final MediaRepo repo;

  int currentIndex = 0;

  int get count => mediaList.length;

  bool get isPlaying => false;

  @protected
  MediaResource? _currentMedia;
  MediaResource? get currentMedia => _currentMedia;

  bool isEmpty(Type type) => this == MediaBloc.empty(type);

  MediaBloc(this.mediaList, this.type, {this.repo = const MediaRepo()});
  MediaBloc.empty(Type? type) : this(List.empty(growable: true), type);

  Future<MediaResource>? getNextMedia() async {
    log("MediaBloc - currentIndex is $currentIndex - List size is $count");
    if(currentIndex >= mediaList.length) {
      currentIndex = -1;
    }
    currentIndex += 1;
    log("currentIndex after adjustment is $currentIndex");
    _currentMedia = await getMedia(currentIndex);
    return _currentMedia!;
  }

  Future<MediaResource>? getPreviousMedia() async {
    if(currentIndex <= 0) {
      currentIndex = mediaList.length;
    }
    currentIndex -= 1;
    _currentMedia = await getMedia(currentIndex);
    return _currentMedia!;
  }

  Future<Uint8List?> getThumbnail(int index) async {
    return await repo.getThumbnailBytes(mediaList[index]);
  }

  Future<void> loadCurrentMedia() async {
    _currentMedia = await getMedia(currentIndex);
  }

  Future<MediaResource> getMedia(int index) async {
    MediaData data = mediaList[index];
    if (data.isLocal() && MediaAccess.hasReadPermission) {
      File? mediaFile = repo.getLocalFile(data);
      log("MediaBloc- File == ${mediaFile?.path}");
      Uint8List? mediaBytes = await repo.getBytes(data);
      if(mediaBytes == null) {
        log("MediaBloc- Bytes is null.");
      }
      return MediaResource(data, mediaBytes,
          mediaFile); // ?? Future.error("Unexpected IO error.");
    } else if(MediaAccess.hasReadPermission){
      return Future.error('Not yet implemented');
    } else {
      return Future.error(NeedsPermissionText.NEEDS_PERMISSION);
    }
  }

}
