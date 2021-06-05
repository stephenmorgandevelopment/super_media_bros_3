

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:super_media_bros_3/models/media.dart' as model;

class ImageView extends StatefulWidget {
  final model.Image imageData;
  final Uint8List imageBytes;

  ImageView(this.imageData, this.imageBytes);

  @override
  State createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

  @override
  Widget build(BuildContext context) {
    return Image.memory(
        widget.imageBytes,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      isAntiAlias: true,
    );
  }

}