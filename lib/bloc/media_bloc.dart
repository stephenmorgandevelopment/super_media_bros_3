

import 'dart:typed_data';

import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/models/media_resource.dart';
import 'package:super_media_bros_3/repo/media_repo.dart';

abstract class MediaBloc {
  List<MediaData> mediaList;
  final Type type;

  MediaBloc(this.mediaList, this.type);

  Future<MediaResource> getMedia(int index);
  Future<Uint8List?> getThumbnail(int index);
}

// abstract class MediaBloc {
//   Type _type;
//   Type get type => _type;
//
//   static MediaRepo repo = MediaRepo();
//
//   MediaBloc(this._type, [this.mediaList]);
//
//   List<Media>? mediaList;
//
//   Future<Object?> load(Media media);
// }
