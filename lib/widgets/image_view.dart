import 'dart:ffi';
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
        ? Image.memory(
            media.bytes!,
            fit: BoxFit.contain,
            alignment: Alignment.center,
            isAntiAlias: true,
          )
        : Image.file(
            media.file!,
            fit: BoxFit.contain,
            alignment: Alignment.center,
            isAntiAlias: true,
          );

    return _ImageViewState(image);
  }
}



class _ImageViewState extends State<ImageView> {
  final Image _image;
  bool optionsShowing = false;

  _ImageViewState(this._image);

  @override
  Widget build(BuildContext context) {
    if(optionsShowing) {
      return Stack(
        children: [
          Center(
            child: GestureDetector(
              child: _image,
              onTap: _showOptions,
            ),
          ),
          Container(
            child: Material(
              child: ImageOptionsTop(widget.media),
              type: MaterialType.transparency,
            ),
            constraints: BoxConstraints.expand(),
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.symmetric(vertical: 100.0, horizontal: 22.0),

          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Material(
              child: ImageOptionsBottom(widget.media),
              type: MaterialType.transparency,
            ),
            constraints: BoxConstraints.expand(),
            alignment: Alignment.bottomCenter,
          ),
        ],
      );
    } else {
      return GestureDetector(
        child: _image,
        onTap: _showOptions,
      );
    }
  }

  void _showOptions() {
    optionsShowing = !optionsShowing;
    setState(() {

    });
  }
}


class ImageOptionsTop extends StatelessWidget {
  static final double iconsize = 56.0;

  final MediaResource media;

  ImageOptionsTop(this.media);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: makeOptions(),
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
    );
  }

  List<Widget> makeOptions() {
    return <Widget> [
      IconButton(
          onPressed: () => onPressed("share"),
          iconSize: iconsize,
          icon: Icon(
            Icons.share_outlined,
            color: Colors.white38,
            semanticLabel: "Open the share manager.",
          )),
      IconButton(
          onPressed: () => onPressed("addto"),
          iconSize: iconsize,
          icon: Icon(
            Icons.add_to_photos_outlined,
            color: Colors.white38,
            semanticLabel: "Add this to photos, a gallery, or an album.",
          )),
      IconButton(
          onPressed: () => onPressed("favorite"),
          iconSize: iconsize,
          icon: Icon(
            Icons.favorite_border,
            color: Colors.white38,
            semanticLabel: "Favorite this image.",
          )),
    ];
  }

  void onPressed(String button) {
    switch (button) {
      case "share":

        break;
      case "favorite":

        break;
      case "addto":

        break;
    }
  }
}

class ImageOptionsBottom extends StatelessWidget {
  static final double iconsize = 44.0;
  late BuildContext ctx;

  final MediaResource media;

  ImageOptionsBottom(this.media);

  @override
  Widget build(BuildContext context) {
    this.ctx = context;

    return Row(
      children: makeOptions(),
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
    );
  }

  List<Widget> makeOptions() {
    return <Widget>[
      IconButton(
          onPressed: () => onPressed("bytes"),
          iconSize: iconsize,
          icon: Icon(
            Icons.code,
            color: Colors.white38,
            semanticLabel: "View this image's raw byte data.",
          )),
      IconButton(
          onPressed: () => onPressed("edit"),
          iconSize: iconsize,
          icon: Icon(
            Icons.tune,
            color: Colors.white38,
            semanticLabel: "Open this image in a photo editor.",
          )),
      IconButton(
          onPressed: () => onPressed("copy"),
          iconSize: iconsize,
          icon: Icon(
            Icons.content_copy,
            color: Colors.white38,
            semanticLabel: "Copy this image to another album or folder.",
          )),
      IconButton(
          onPressed: () => onPressed("move"),
          iconSize: iconsize,
          icon: Icon(
            Icons.drive_file_move_outlined,
            color: Colors.white38,
            semanticLabel: "Move this image to another album or folder.",
          )),
      IconButton(
          onPressed: () => onPressed("delete"),
          iconSize: iconsize,
          icon: Icon(
            Icons.delete_outlined,
            color: Colors.white38,
            semanticLabel: "Delete this image.",
          )),
      IconButton(
          onPressed: () => onPressed("details"),
          iconSize: iconsize,
          icon: Icon(
            Icons.info_outlined,
            color: Colors.white38,
            semanticLabel: "View details from the image metadata.",
          )),
    ];
  }

  void onPressed(String button) async {
    switch (button) {
      case "bytes":

        Uint8List? bytes = media.bytes ??
            await media.file?.readAsBytes();

        if(bytes != null) {
          ByteData bdata = bytes.buffer.asByteData(0, bytes.lengthInBytes);
          StringBuffer stringBuffer = StringBuffer();
          for(int i = 0; i < bdata.lengthInBytes; i + 512) {
            if((bdata.lengthInBytes - i) > 512) {
              stringBuffer.write(bdata.buffer.asByteData(i, 512));
            } else {
              stringBuffer.write(bdata.buffer.asByteData(i, (bdata.lengthInBytes - i)));
            }

          }
          Widget text = Text(
            stringBuffer.toString(),
            softWrap: true,
          );

          Navigator.push(ctx, MaterialPageRoute(builder: (context) => text));
        }
        break;
      case "edit":

        break;
      case "copy":

        break;
      case "move":

        break;
      case "share":

        break;
      case "details":

        break;
    }
  }
}
