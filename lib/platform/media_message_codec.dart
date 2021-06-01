import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:super_media_bros_3/models/media.dart';

class MediaMessageCodec extends StandardMessageCodec {
  const MediaMessageCodec();

  static const int _kUri = 164;
  static const int _kMap = 165;

  static const int _kType = 166;
  static const int _kIMAGE = 200;
  static const int _kVIDEO = 201;
  static const int _kAUDIO = 202;

  @override
  void writeValue(WriteBuffer buffer, dynamic value) {
    if (value is Uri) {
      buffer.putUint8(_kUri);

      ByteBuffer uriByteBuffer = (value as ByteBuffer);
      writeSize(buffer, uriByteBuffer.lengthInBytes);
      buffer.putUint8List(uriByteBuffer.asUint8List());
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
    } else if (value is Map) {
      buffer.putUint8(_kMap);

      writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    late Uri uri;
    late Map<String, String> metadata;
    // late Type _type;

    switch (type) {
      case _kUri:
        uri = readValue(buffer)! as Uri;
        break;
      case _kMap:
        metadata = super.readValueOfType(type, buffer) as Map<String, String>;
        break;
      case _kType:
        switch(buffer.getUint8()) {
          case _kIMAGE:
            // return Image(uri, metadata: metadata);
          case _kVIDEO:
            // _type = Type.VIDEO;
            break;
          case _kAUDIO:
            // _type = Type.AUDIO;
            break;
        }
    }


  }
}
