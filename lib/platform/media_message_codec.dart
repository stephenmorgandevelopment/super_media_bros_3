import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:super_media_bros_3/models/AudioPlayerState.dart';
import 'package:super_media_bros_3/models/SuperMediaCommand.dart';
import 'package:super_media_bros_3/models/media_data.dart';

class MediaMessageCodec extends StandardMessageCodec {
  const MediaMessageCodec();

  static const int _kMedia = 163;
  static const int _kUri = 164;

  static const int _kType = 166;
  static const int _kImage = 200;
  static const int _kVideo = 201;
  static const int _kAudio = 202;
  
  static const int _kAudioPlayerState = 210;
  static const int _kPlayerCommand = 211;
  static const int _kSuperMediaState = 214;


  /// Override of MediaMessageCodec.writeValue
  /// This constructs the byte array that Flutter will send to the
  /// platform.
  ///
  /// buffer is the actual bytes that will be sent to the platform.  We must
  /// first write an identifier, to the buffer which notifies, the platform side
  /// codec, that we are beginning a new object of a certain type.
  ///
  /// Once we've written the identifying byte.  We then write the objects primitives
  /// is a certain order, to be de-serialized on the other end.  If there are
  /// class members which are not primitives, then they must be parsed out in the
  /// same manner as our top level objects.



  @override
  void writeValue(WriteBuffer buffer, dynamic value) {
    if (value is MediaData) {
      buffer.putUint8(_kMedia);

      writeValue(buffer, value.uri.toString());
      writeValue(buffer, value.type);
      writeValue(buffer, value.metadata);
    } else if (value is Type) {
      switch (value) {
        case Type.IMAGE:
          buffer.putUint8(_kType);
          buffer.putUint8(_kImage);
          break;
        case Type.VIDEO:
          buffer.putUint8(_kType);
          buffer.putUint8(_kVideo);
          break;
        case Type.AUDIO:
          buffer.putUint8(_kType);
          buffer.putUint8(_kAudio);
          break;
      }
    } else if(value is SuperMediaCommand) {
      buffer.putUint8(_kPlayerCommand);
      buffer.putUint32(value.command);
    } else if (value is Uri) {
      // Left here in case I want to send Uri's later.
      buffer.putUint8(_kUri);
      super.writeValue(buffer, value.toString());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case _kMedia:
        Uri uri = Uri.parse(readValue(buffer) as String);
        Type _type = readValue(buffer) as Type;
        Map<Object?, Object?> map = readValue(buffer) as Map<Object?, Object?>;

        Map<String, String> metadata = LinkedHashMap.from(map);
        return makeMedia(uri, _type, metadata);
      case _kType:
        switch (buffer.getUint8()) {
          case _kImage:
            return Type.IMAGE;
          case _kVideo:
            return Type.VIDEO;
          case _kAudio:
            return Type.AUDIO;
          default:
            return null;
        }
      case _kUri:
        return Uri.parse(readValue(buffer) as String);
      case _kAudioPlayerState:
        AudioPlayerState playerState =
                  AudioPlayerState(Uri.parse(readValue(buffer) as String));

        playerState.state = SuperMediaState.values[(readValue(buffer) as int)];
        playerState.position = readValue(buffer) as int;
        playerState.isPlaying = readValue(buffer) as bool;
        playerState.isReady = readValue(buffer) as bool;
        playerState.isPreparing = readValue(buffer) as bool;
        playerState.isError = readValue(buffer) as bool;
        playerState.isBuffering = readValue(buffer) as bool;

        return playerState;
      case _kSuperMediaState:
        return  SuperMediaState.values[(readValue(buffer) as int)];
      default:
        return super.readValueOfType(type, buffer);
    }
  }

  MediaData makeMedia(Uri uri, Type type, Map<String, String> metadata) {
    switch (type) {
      case Type.IMAGE:
        return ImageData(uri, Source.LOCAL, metadata: metadata);
      case Type.VIDEO:
        return VideoData(uri, Source.LOCAL, metadata: metadata);
      case Type.AUDIO:
        return AudioData(uri, Source.LOCAL, metadata: metadata);
    }
  }
}
