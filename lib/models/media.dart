

import 'dart:collection';

enum Type {
  IMAGE, VIDEO, AUDIO
}

abstract class Media {
  Uri uri;
  Map<String, String> metadata;

  Type _type;
  Type get type => _type;

  Media(this.uri, this._type, {this.metadata = const <String, String>{}});

  void addMetadata(Map<String, String> metadata) {
    this.metadata = metadata;
  }


}

//TODO Experiment and see if splitting the following classes into
//TODO individual files has an affect on apk/install/compile size.

class Image extends Media {
  Image(uri, {metadata}) : super(uri, Type.IMAGE, metadata: metadata ?? null);
  //TODO Put a predefined Map<> here for lightweight instances with limited metadata.
}

class Video extends Media {
  Video(uri, {metadata}) : super(uri, Type.VIDEO, metadata: metadata ?? null);
  //TODO Put a predefined Map<> here for lightweight instances with limited metadata.
}

class Audio extends Media {
  Audio(uri, {metadata}) : super(uri, Type.AUDIO, metadata: metadata ?? null);
  //TODO Put a predefined Map<> here for lightweight instances with limited metadata.
}
