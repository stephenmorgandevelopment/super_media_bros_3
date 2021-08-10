import 'dart:collection';

import 'package:super_media_bros_3/mediaplayer/media_options.dart';

enum Type { IMAGE, VIDEO, AUDIO }

enum Source { LOCAL, CLOUD }

abstract class MediaData {
  final Uri uri;
  final Type type;
  final Source source;

  Map<String, String> metadata;

  MediaData(this.uri, this.type, this.source,
      {this.metadata = const <String, String>{}});

  void addMetadata(Map<String, String> metadata) {
    this.metadata = metadata;
  }

  bool isLocal() => source == Source.LOCAL;
}

class ImageData extends MediaData {
  ImageData(Uri uri, Source source,
      {Map<String, String> metadata = const <String, String>{}})
      : super(uri, Type.IMAGE, source, metadata: metadata);
}

class VideoData extends MediaData {
  VideoData(Uri uri, Source source,
      {Map<String, String> metadata = const <String, String>{}})
      : super(uri, Type.VIDEO, source, metadata: metadata);
}

class AudioData extends MediaData {
  AudioData(Uri uri, Source source,
      {Map<String, String> metadata = const <String, String>{}})
      : super(uri, Type.AUDIO, source, metadata: metadata);

  static Map<String, int> parseAudioList(List<MediaData> mediaList) {
    Map<String, int> audioIndexes = LinkedHashMap();

    String currentGroup = "";
    for(int i = 0; i < mediaList.length; i++) {
      String? group = mediaList[i].metadata[MediaOptions.audioGroupBy];

      if(group == null) {
        audioIndexes["nodata$i"] = i;
        continue;
      }

      if(group != currentGroup) {
        currentGroup = group;
        audioIndexes[group] = i;
      }
    }

    return audioIndexes;
  }
}
