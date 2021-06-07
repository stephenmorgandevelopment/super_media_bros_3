

import 'dart:typed_data';

import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/models/media_resource.dart';

abstract class MediaBloc {
  List<MediaData> mediaList;
  final Type type;

  MediaBloc(this.mediaList, this.type);

  Future<MediaResource> getMedia(int index);
  Future<Uint8List?> getThumbnail(int index);
}
