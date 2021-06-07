

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/models/media_resource.dart';

class ImageView extends StatefulWidget {
  final MediaResource media;

  ImageView(this.media);

  @override
  State createState() {
    Image image = media.bytes != null
        ? Image.memory(media.bytes!, fit: BoxFit.contain, alignment: Alignment.center, isAntiAlias: true,)
        : Image.file(media.file!, fit: BoxFit.contain, alignment: Alignment.center, isAntiAlias: true,);

    return _ImageViewState(image);
  }
}

class _ImageViewState extends State<ImageView> {
  final Image _image;

  _ImageViewState(this._image);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: _image,
        onTap: _showOptions,
    );
  }

  void _showOptions() {

  }
}

// class ImageOptions extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: OptionButtons(),
//     );
//   }
//
//   Widget[] OptionButtons() {
//
//
//     return <Widget>[];
//   }
// }