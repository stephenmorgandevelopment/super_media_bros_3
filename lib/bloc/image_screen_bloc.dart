

import 'dart:typed_data';

import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/data/image_access.dart';
import 'package:super_media_bros_3/models/media.dart';

class ImageScreenBloc extends MediaBloc{
  ImageScreenBloc([List<Media>? mediaList]) : super(Type.IMAGE, mediaList);

  // Future<Uint8List> getImage(Image image) async {
  //   ImageAccess.
  // }
}