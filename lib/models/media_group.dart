

import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/models/media_data.dart';

enum By {ALBUM, ARTIST, GENRE, PLAYLIST, FOLDER}

extension Utils on By {
  String value() {
    String tmp = this.toString();
    return tmp.substring(tmp.indexOf(".") + 1).toLowerCase();
  }

  By fromString(String byString) {
    for(By by in By.values) {
      if(by.value() == byString.toLowerCase()) {
        return by;
      }
    }
    return MediaOptions.defaultGroupBy;
  }
}

class MediaGroup {
  String groupName;
  By grouping;
  List<MediaData> _mediaList;
  
  MediaGroup(this.groupName, this.grouping, this._mediaList);

}