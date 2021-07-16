

import 'dart:io';
import 'dart:typed_data';

import 'package:super_media_bros_3/models/media_data.dart';

class MediaResource {
  final Uint8List? _bytes;
  Uint8List? get bytes => _bytes;

  final File? _file;
  File? get file => _file;

  MediaData _data;
  MediaData get data => _data;

  MediaResource(this._data, this._bytes, this._file) {
    if(_bytes == null && _file == null) {
      throw Error();
    }
  }

  MediaResource.withBytes(
      MediaData data,
      Uint8List bytes) : this(data, bytes, null);

  MediaResource.withFile(
      MediaData data,
      File file) : this(data, null, file);

}