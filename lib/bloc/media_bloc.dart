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

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentIndex(int index) {
    _currentIndex = index;
    loadCurrentMedia();
  }

  bool isPlaying = false;

  @protected
  MediaResource? _currentMedia;
  MediaResource? get currentMedia => _currentMedia;

  bool get isEmpty => this == MediaBloc.empty();

  MediaBloc(this.mediaList, this.type, {this.repo = const MediaRepo()});
  MediaBloc.empty() : this(List.empty(growable: true), null);

  Future<MediaResource>? getNextMedia() async {
    if(_currentIndex >= mediaList.length) {
      _currentIndex = -1;
    }
    _currentIndex += 1;
    _currentMedia = await getMedia(_currentIndex);
    return _currentMedia!;
  }

  Future<MediaResource>? getPreviousMedia() async {
    if(_currentIndex <= 0) {
      _currentIndex = mediaList.length;
    }
    _currentIndex -= 1;
    _currentMedia = await getMedia(_currentIndex);
    return _currentMedia!;
  }

  Future<Uint8List?> getThumbnail(int index) async {
    return await repo.getThumbnailBytes(mediaList[index]);
  }

  void loadCurrentMedia() async {
    _currentMedia = await getMedia(_currentIndex);
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
