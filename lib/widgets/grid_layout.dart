import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:super_media_bros_3/data/image_access.dart';
import 'package:super_media_bros_3/data/media_interface.dart';

import 'package:super_media_bros_3/models/media.dart';

class MediaGridLayout extends StatefulWidget {
  final int columnCount; //TODO Set according to default preferences.
  final bool horizontal;
  final List<Media> media;

  MediaGridLayout(
      {this.columnCount = 3,
      this.horizontal = false,
      this.media = const <Media>[]});

  @override
  State createState() => _MediaGridLayoutState();
}

class _MediaGridLayoutState extends State<MediaGridLayout> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.columnCount,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 4.0,
        ),
        scrollDirection: widget.horizontal ? Axis.horizontal : Axis.vertical,
        itemCount: widget.media.isNotEmpty ? widget.media.length : 6, //itemCount: widget.media.size();
        itemBuilder: (BuildContext context, int index) {
          if(widget.media.isNotEmpty) {
            // return img.Image.asset('images/logo1.png');
            Media media = widget.media[index];
            String? filePath = media.metadata['_data'];
            String? relativePath = media.metadata['relative_path'];

            File image;
            if(filePath != null) {
              image = File(filePath);
              return img.Image.file(image);
            // } else if(relativePath != null) {
            //   image = File(relativePath);
            //   return img.Image.file(image);
            }

            return img.Image.asset('images/logo1.png');
          } else {
            return buildGeneric(context, index);
          }
        },);
  }

  Future<List<Media>> getMedia() async {
    List<Media> media = await ImageAccess.getAllImagesData();


    return media;
  }

  Widget buildGeneric(BuildContext context, int index) {
    switch (index) {
      case 0:
        return img.Image.asset('images/audio.png');
      case 1:
        return img.Image.asset('images/home.png');
      case 2:
        return img.Image.asset('images/logo1.png');
      case 3:
        return img.Image.network(
            'https://www.stephenmorgan-portfolio.com/images/photos/DSC_0156.jpg');
      case 4:
        return img.Image.network(
            'https://www.stephenmorgan-portfolio.com/images/jim1.png');
      default:
        return img.Image.network(
            'https://www.stephenmorgan-portfolio.com/images/jim2.png');
    }
  }



  List<Row> buildRows() {
    List<Row> rows = [];

    return rows;
  }
}
