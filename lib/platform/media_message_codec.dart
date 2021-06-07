import 'dart:collection';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_media_bros_3/models/media_data.dart';

class MediaMessageCodec extends StandardMessageCodec {
  const MediaMessageCodec();

  static const int _kMedia = 163;
  static const int _kUri = 164;

  static const int _kType = 166;
  static const int _kIMAGE = 200;
  static const int _kVIDEO = 201;
  static const int _kAUDIO = 202;

  @override
  void writeValue(WriteBuffer buffer, dynamic value) {
    if(value is MediaData) {
      buffer.putUint8(_kMedia);

      writeValue(buffer, value.uri.toString());
      // writeValue(buffer, value.uri as String);
      writeValue(buffer, value.type);
      writeValue(buffer, value.metadata);
    } else if (value is Type) {
      switch (value) {
        case Type.IMAGE:
          buffer.putUint8(_kType);
          buffer.putUint8(_kIMAGE);
          break;
        case Type.VIDEO:
          buffer.putUint8(_kType);
          buffer.putUint8(_kVIDEO);
          break;
        case Type.AUDIO:
          buffer.putUint8(_kType);
          buffer.putUint8(_kAUDIO);
          break;
      }
    } else if(value is Uri) { // Left here in case I want to send Uri's later.
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
        switch(buffer.getUint8()) {
          case _kIMAGE: return Type.IMAGE;
          case _kVIDEO: return Type.VIDEO;
          case _kAUDIO: return Type.AUDIO;
          default: return null;
        }
      case _kUri:
        return Uri.parse(readValue(buffer) as String);
      default:
        return super.readValueOfType(type, buffer);
    }
  }

  MediaData makeMedia(Uri uri, Type type, Map<String, String> metadata) {
    switch(type) {
      case Type.IMAGE:
        return ImageData(uri, Source.LOCAL, metadata: metadata);
      case Type.VIDEO:
        return VideoData(uri, Source.LOCAL, metadata: metadata);
      case Type.AUDIO:
        return AudioData(uri, Source.LOCAL, metadata: metadata);
    }
  }
}
