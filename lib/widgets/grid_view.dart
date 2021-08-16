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
    // for(MapEntry entry in audioIndexes!.entries) {
    //
    // }
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

  int mapMediaListIndexToAudioIndex(int index) {
    int i = 0;
    for(MapEntry entry in audioIndexes!.entries) {
      if(i++ == index) {
        return entry.value;
      }
    }
    return index;
  }

  int mapEndingIndex(int index) {
    log("index: $index");

    bool returnNext = false;
    for(MapEntry entry in audioIndexes!.entries) {
      if(returnNext) {
        log("endingIndex: ${entry.value - 1}");
        return (entry.value - 1);
      }

      if(entry.value == index) {
        returnNext = true;
      }
    }

    return (widget.bloc.audioList.length - 1);
  }

  Widget Function(BuildContext, int) get builderSelect => widget.bloc.type == Type.AUDIO ?
      audioBuilder :
      builder;

  Widget audioBuilder(BuildContext context, int index) {
    return builder(context, mapMediaListIndexToAudioIndex(index));
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
        // TODO Extract and cleanup.  Temp to verify correct ranges.
        int endingIndex = mapEndingIndex(index);
        List<MediaData> groupData = widget.bloc.audioList.getRange(
          index,
          endingIndex
        ).toList()..add(widget.bloc.audioList[endingIndex]);

        Uint8List? thumbnail = await widget.bloc.getThumbnail(index);
        Widget artwork = thumbnail != null
            ? Image.memory(thumbnail, fit: BoxFit.cover)
            : Icon(Icons.audiotrack_outlined);

        List<Widget> listViewChildren = List.empty(growable: true);
        for(MediaData track in groupData) {
          listViewChildren.add(
            ListTile(
              leading: artwork,
              title: Text(track.metadata["_display_name"]!),
            )
          );
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              body: ListView(
              children: listViewChildren,
            ),
          ),
          ),
        );
        break;
      default:
        log(widget.bloc.type.toString() + index.toString());
        break;
    }
  }
}
