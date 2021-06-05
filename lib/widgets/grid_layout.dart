import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: implementation_imports
import "package:flutter/src/widgets/image.dart" as img;
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/data/image_access.dart';

import 'package:super_media_bros_3/models/media.dart';
import 'package:super_media_bros_3/models/media.dart' as my;
import 'package:super_media_bros_3/widgets/media_widgets.dart';

class MediaGridLayout extends StatefulWidget {
  final int columnCount; //TODO Set according to default preferences.
  final bool horizontal;
  final MediaBloc bloc;

  MediaGridLayout(
      this.bloc,
      {this.columnCount = 3,
      this.horizontal = false});
      // this.media = const <Media>[]});

  @override
  State createState() => _MediaGridLayoutState();
}

class _MediaGridLayoutState extends State<MediaGridLayout> {
  // Future<Media?>? mediaData(int index) => ImageAccess.getData();


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.columnCount,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 4.0,
      ),
      scrollDirection: widget.horizontal ? Axis.horizontal : Axis.vertical,
      itemCount: widget.bloc.mediaList!.length,
      itemBuilder: (BuildContext context, int index) {
        final Media media = widget.bloc.mediaList![index];

        return FutureBuilder(
            future: getThumbnailBytes(media),
            builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                        return InkResponse(
                          onTap: () {navigate(context, media as my.Image);},
                          onLongPress: null,
                          child: img.Image.memory(snapshot.data!),
                        );
                      } else if(snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        return img.Image.asset('images/logo1.png');
                      }
            });
      },
    );
  }

  Future<void> navigate(BuildContext context, my.Image image) async {
    Uint8List? bytes = await ImageAccess.getImage(image);
    if(bytes != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ImageView(image, bytes))
      );
    }
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

  Widget? getFullImageFromFile(Media media) {
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

}
