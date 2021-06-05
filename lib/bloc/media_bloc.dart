

import 'package:super_media_bros_3/models/media.dart';

abstract class MediaBloc {
  Type _type;
  Type get type => _type;

  MediaBloc(this._type, [this.mediaList]);

  List<Media>? mediaList;
}