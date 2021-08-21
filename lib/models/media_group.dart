

import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/models/media_data.dart';

class MediaGroup {
  String groupName;
  AudioCategory grouping;
  List<MediaData> _mediaList;
  
  MediaGroup(this.groupName, this.grouping, this._mediaList);

}