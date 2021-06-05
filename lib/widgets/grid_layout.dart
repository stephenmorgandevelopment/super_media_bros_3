import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: implementation_imports
import "package:flutter/src/widgets/image.dart" as img;
import 'package:super_media_bros_3/data/image_access.dart';

import 'package:super_media_bros_3/models/media.dart';
import 'package:super_media_bros_3/models/media.dart' as my;

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
  Future<Media?>? mediaData(int index) => ImageAccess.getData(widget.media[index]);
  // Future<List<Uint8List>> thumbnails = ImageAccess.getAllImageThumbnails();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.columnCount,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 4.0,
      ),
      scrollDirection: widget.horizontal ? Axis.horizontal : Axis.vertical,
      itemCount: widget.media.isNotEmpty ? widget.media.length : 6,
      //itemCount: widget.media.size();
      itemBuilder: (BuildContext context, int index) {
        return FutureBuilder(
            future: getThumbnailBytes(widget.media[index]),
            builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                        // log("GridLayout ${snapshot.data.toString()}");
                        // return Text(snapshot.data!.metadata.toString());
                        return img.Image.memory(
                            snapshot.data!,
                        );
                      } else if(snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        return img.Image.asset('images/logo1.png');
                      }
            });
        // return FutureBuilder(
        //     future: thumbnails,
        //     // future: ImageAccess.getImageThumbnail(widget.media[index] as my.Image),
        //     builder: (BuildContext context, AsyncSnapshot<List<Uint8List>> snapshot) {
        //       if (snapshot.hasData) {
        //         // log("GridLayout ${snapshot.data.toString()}");
        //         // return Text(snapshot.data!.metadata.toString());
        //         return img.Image.memory(
        //             snapshot.data![index],
        //         );
        //       } else if(snapshot.hasError) {
        //         return Text(snapshot.error.toString());
        //       } else {
        //         return img.Image.asset('images/logo1.png');
        //       }
        //   },
        //
        // );

        if (widget.media.isNotEmpty) {
          // return getFullImage(widget.media[index]) ??
          //     img.Image.asset('images/logo1.png');
        } else {
          return buildGeneric(context, index);
        }
      },
    );
  }

  Future<Uint8List?> getThumbnailBytes(Media media) async {
    switch(media.type) {
      case Type.IMAGE:
        return await ImageAccess.getImageThumbnail(media as my.Image);
      case Type.VIDEO:
        return null;
      case Type.AUDIO:
        return null;
    }
  }

  Future<Widget?> getThumbnail(Media media) async {
    switch (media.type) {
      case Type.IMAGE:
        return img.Image.memory(
            await ImageAccess.getImageThumbnail(media as my.Image) ?? Uint8List(0));
      case Type.VIDEO:
        return null;
      case Type.AUDIO:
        return null;
    }
  }

  Widget? getFullImage(Media media) {
    String? filePath = media.metadata['_data'];
    String? relativePath = media.metadata['relative_path'];

    File image;
    if (filePath != null) {
      image = File(filePath);
      return img.Image.file(image);
    } else if (relativePath != null) {
      log("Used relative path for $media");
      image = File(relativePath);
      return img.Image.file(image);
    }
    return null;
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
