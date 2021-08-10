import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/models/media_resource.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';
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
  Map<String, int>? audioIndexes;

  @override
  void initState() {
    if(widget.bloc.type == Type.AUDIO) {
      parseAudioList();
    }

    super.initState();
  }

  void parseAudioList() {//async {
    audioIndexes = AudioData.parseAudioList(widget.bloc.audioList);

  }

  @override
  Widget build(BuildContext context) {
    SliverGridDelegate delegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: widget.columnCount,
      crossAxisSpacing: 6.0,
      mainAxisSpacing: 6.0,
    );

    return Material(
      type: MaterialType.transparency,
      child: GridView.builder(
        gridDelegate: delegate,
        scrollDirection: widget.horizontal ? Axis.horizontal : Axis.vertical,
        itemCount: widget.bloc.type != Type.AUDIO
            ? widget.bloc.count
            : audioIndexes!.length,
        itemBuilder: builderSelect,
      ),
    );
  }

  int mapAudioIndex(int index) {
    int i = 0;
    for(MapEntry entry in audioIndexes!.entries) {
      // TODO Change to (i++ == index) and verify consistency.
      if(i++ == index) {
        return entry.value;
      }
    }
    return index;
  }

  Widget Function(BuildContext, int) get builderSelect => widget.bloc.type == Type.AUDIO ?
      audioBuilder :
      builder;

  Widget audioBuilder(BuildContext context, int index) {
    return builder(context, mapAudioIndex(index));
  }

  Widget builder(BuildContext context, int index) {
    return FutureBuilder(
        future: widget.bloc.getThumbnail(index),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return InkResponse(
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
            return IconButton(
              onPressed: () {
                navigate(context, index);
              },
              icon: defaultIcon,
            );
          }
        });
  }

  Icon get defaultIcon {
    switch (widget.bloc.type) {
      case Type.IMAGE:
        return Icon(Icons.image_outlined);
      case Type.VIDEO:
        return Icon(Icons.movie_outlined);
      case Type.AUDIO:
        return Icon(Icons.audiotrack_outlined);
      default:
        return Icon(Icons.description_outlined);
    }
  }

  Future<void> navigate(BuildContext context, index) async {
    widget.bloc.currentIndex = index;
    await widget.bloc.loadCurrentMedia();
    switch (widget.bloc.type) {
      case Type.IMAGE:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MediaControllerBlocProvider(widget.bloc,
                  child: ImageView(widget.bloc))),
        );
        break;
      case Type.VIDEO:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaControllerBlocProvider(widget.bloc,
                child: VideoView()),
          ),
        );
        break;
      case Type.AUDIO:
        // List<MediaData> groupData = widget.bloc.audioList
        // MediaBloc groupBloc = MediaBloc()
        //
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => MediaGridLayout()
        //   )
        // )

      default:
        log(widget.bloc.type.toString() + index.toString());
        break;
    }
  }
}
