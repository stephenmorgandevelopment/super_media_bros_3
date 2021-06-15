import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:super_media_bros_3/data/media_interface.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/models/media_resource.dart';
import 'package:super_media_bros_3/repo/media_repo.dart';

class MediaBloc {
  @protected
  List<MediaData> mediaList;
  final Type? type;
  @protected
  final MediaRepo repo;

  @protected
  int? _currentIndex;
  @protected
  MediaResource? _currentMedia;
  @protected
  MediaResource? get currentMedia => _currentMedia;

  MediaBloc(this.mediaList, this.type, {this.repo = const MediaRepo()});

  Future<Uint8List?> getThumbnail(int index) async {
    return await repo.getThumbnailBytes(mediaList[index]);
  }

  Future<MediaResource> getMedia(int index) async {
    MediaData data = mediaList[index];
    if (data.isLocal() && MediaAccess.hasReadPermission) {
      File? mediaFile = repo.getLocalFile(data);
      Uint8List? mediaBytes = await repo.getBytes(data);
      return MediaResource(data, mediaBytes,
          mediaFile); // ?? Future.error("Unexpected IO error.");
    } else {
      return Future.error('Not yet implemented');
    }
  }
}
