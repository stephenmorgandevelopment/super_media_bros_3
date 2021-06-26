import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/models/media_resource.dart';
import 'package:super_media_bros_3/widgets/image_view.dart';
import 'package:super_media_bros_3/widgets/video_view.dart';

int columnCnt = 3;

class MediaGridLayout extends StatefulWidget {
  final int columnCount; //TODO Set according to default preferences.
  final bool horizontal;
  final MediaBloc bloc;

  MediaGridLayout(this.bloc, {this.columnCount = 3, this.horizontal = false});

  @override
  State createState() => _MediaGridLayoutState();
}

class _MediaGridLayoutState extends State<MediaGridLayout> {
  Future<MediaResource> mediaFuture(int index) => widget.bloc.getMedia(index);

  @override
  Widget build(BuildContext context) {
    SliverGridDelegate delegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: widget.columnCount,
      crossAxisSpacing: 6.0,
      mainAxisSpacing: 6.0,
    );

    return GridView.builder(
      gridDelegate: delegate,
      scrollDirection: widget.horizontal ? Axis.horizontal : Axis.vertical,
      itemCount: widget.bloc.mediaList.length,
      itemBuilder: (BuildContext context, int index) => builder(context, index),

      // itemBuilder: (BuildContext context, int index) {
    );
  }

  Widget builder(BuildContext context, int index) {
    return FutureBuilder(
        future: widget.bloc.getThumbnail(index),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return InkResponse(
              //Will be tyring to implement MatDes.
              onTap: () {
                navigate(context, index);
              },
              onLongPress: null,
              child: Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Image.asset('images/logo1.png');
          }
        });
  }

  Future<void> navigate(BuildContext context, index) async {
    widget.bloc.currentIndex = index;
    switch (widget.bloc.type) {
      case Type.IMAGE:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ImageView(widget.bloc)));
        break;
      case Type.VIDEO:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => VideoView(widget.bloc)));
        break;
      case Type.AUDIO:
      //TODO Instantiate and navigate to audio player
      //TODO Start player service.

      default:
        log(widget.bloc.type.toString() + index.toString());
        break;
    }
  }
}
