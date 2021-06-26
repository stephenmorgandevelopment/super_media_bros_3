import 'package:flutter/material.dart';
import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/mediaplayer/media_player_config.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:video_player/video_player.dart';

class MediaControls extends StatefulWidget {
  MediaData data;
  final VideoPlayerController controller;

  MediaControls(this.data, this.controller);

  @override
  State<StatefulWidget> createState() => _MediaControlsState();
}

class _MediaControlsState extends State<MediaControls> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: makeControls(),
      constraints: BoxConstraints.expand(),
      alignment: Alignment.center,
    );
  }

  // TODO Pull controls config from MediaPlayerConfig.
  Widget makeControls() {
    List<ControlGroup> groups = <ControlGroup>[
      ControlGroup(<IconButton>[playBtn], alignment: Alignment.center),
      ControlGroup(<IconButton>[seekBackBtn, seekFwdBtn],
          alignment: Alignment.bottomRight),
      ControlGroup(<IconButton>[prevBtn, nextBtn],
          alignment: Alignment.topRight),
      ControlGroup(<IconButton>[speedBtn, detailsBtn],
          alignment: Alignment.bottomLeft),
    ];

    List<Widget> controlWidgets = List.empty(growable: true);
    for (ControlGroup group in groups) {
      controlWidgets.add(group.compose());
    }

    return Material(
      elevation: 7.0,
      child: Stack(
        fit: StackFit.passthrough,
        children: controlWidgets,
      ),
      type: MaterialType.transparency,
    );
  }

  void onPressed(String button) async {
    switch (button) {
      case "play-pause":
        if (widget.controller.value.isPlaying) {
          widget.controller.pause();
        } else {
          widget.controller.play();
        }
        setState(() {});
        break;
      case "seek-fwd":
        int curPos = (await widget.controller.position)?.inMilliseconds ?? 0;
        Duration newPos =
            Duration(milliseconds: (curPos + MediaOptions.seekForwardTime));
        widget.controller.seekTo(newPos);
        break;
      case "seek-back":
        int curPos = (await widget.controller.position)?.inMilliseconds ?? 0;
        Duration newPos =
            Duration(milliseconds: (curPos - MediaOptions.seekBackwardsTime));
        widget.controller.seekTo(newPos);
        break;
      case "next":
        break;
      case "prev":
        break;
      case "details":
        break;
      case "speed":
        break;
    }
  }

  IconButton get playBtn => IconButton(
      onPressed: () => onPressed("play-pause"),
      iconSize: MediaOptions.iconsize * 2.5,
      icon: Icon(
        widget.controller.value.isPlaying
            ? Icons.pause_circle_filled_outlined
            : Icons.play_circle_fill_outlined,
        color: Colors.white38,
        semanticLabel: "Play or pause the video.",
      ));

  IconButton get speedBtn => IconButton(
      onPressed: () => onPressed("speed"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.slow_motion_video_outlined,
        color: Colors.white38,
        semanticLabel: "Adjust playback speed of the video.",
      ));

  IconButton get prevBtn => IconButton(
      onPressed: () => onPressed("prev"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.skip_previous_outlined,
        color: Colors.white38,
        semanticLabel: "Previous video.",
      ));

  IconButton get seekBackBtn => IconButton(
      onPressed: () => onPressed("seek-back"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.fast_rewind_outlined,
        color: Colors.white38,
        semanticLabel: "Seek backwards in the video.",
      ));

  IconButton get seekFwdBtn => IconButton(
      onPressed: () => onPressed("seek-fwd"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.fast_forward_outlined,
        color: Colors.white38,
        semanticLabel: "Seek forward in the video.",
      ));

  IconButton get nextBtn => IconButton(
      onPressed: () => onPressed("next"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.skip_next_outlined,
        color: Colors.white38,
        semanticLabel: "Next video.",
      ));

  IconButton get detailsBtn => IconButton(
      onPressed: () => onPressed("details"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.info_outlined,
        color: Colors.white38,
        semanticLabel: "View details about the video.",
      ));

  IconButton get shareBtn => IconButton(
      onPressed: () => onPressed("share"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.share_outlined,
        color: Colors.white38,
        semanticLabel: "Open the share manager.",
      ));

  IconButton get addToBtn => IconButton(
      onPressed: () => onPressed("addto"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.add_to_photos_outlined,
        color: Colors.white38,
        semanticLabel: "Add this to photos, a gallery, or an album.",
      ));

  IconButton get favoriteBtn => IconButton(
      onPressed: () => onPressed("favorite"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.favorite_border,
        color: Colors.white38,
        semanticLabel: "Favorite this image.",
      ));

  IconButton get bytesBtn => IconButton(
      onPressed: () => onPressed("bytes"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.code,
        color: Colors.white38,
        semanticLabel: "View this image's raw byte data.",
      ));

  IconButton get editBtn => IconButton(
      onPressed: () => onPressed("edit"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.tune,
        color: Colors.white38,
        semanticLabel: "Open this image in a photo editor.",
      ));

  IconButton get copyBtn => IconButton(
      onPressed: () => onPressed("copy"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.content_copy,
        color: Colors.white38,
        semanticLabel: "Copy this image to another album or folder.",
      ));

  IconButton get moveBtn => IconButton(
      onPressed: () => onPressed("move"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.drive_file_move_outlined,
        color: Colors.white38,
        semanticLabel: "Move this image to another album or folder.",
      ));

  IconButton get deleteBtn => IconButton(
      onPressed: () => onPressed("delete"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.delete_outlined,
        color: Colors.white38,
        semanticLabel: "Delete this image.",
      ));

  IconButton get imgDetailsBtn => IconButton(
      onPressed: () => onPressed("details"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.info_outlined,
        color: Colors.white38,
        semanticLabel: "View details from the image metadata.",
      ));

// @override
// Widget build(BuildContext context) {
// return Column(
// children: makeOptions(),
// mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.end,
// mainAxisSize: MainAxisSize.min,
// );
// }

// List<Widget> makeOptions() {
// return <Widget>[

// Widget build(BuildContext context) {
// this.ctx = context;
//
// return Row(
// children: makeOptions(),
// crossAxisAlignment: CrossAxisAlignment.end,
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// mainAxisSize: MainAxisSize.min,
// );
// }

// void onPressed(String button) async {
// switch (button) {
// case "bytes":
// Uint8List? bytes = media.bytes ?? await media.file?.readAsBytes();
//
// if (bytes != null) {
// ByteData bdata = bytes.buffer.asByteData(0, bytes.lengthInBytes);
// StringBuffer stringBuffer = StringBuffer();
// for (int i = 0; i < bdata.lengthInBytes; i + 512) {
// if ((bdata.lengthInBytes - i) > 512) {
// stringBuffer.write(bdata.buffer.asByteData(i, 512));
// } else {
// stringBuffer
//     .write(bdata.buffer.asByteData(i, (bdata.lengthInBytes - i)));
// }
// }
// Widget text = Text(
// stringBuffer.toString(),
// softWrap: true,
// );
//
// Navigator.push(ctx, MaterialPageRoute(builder: (context) => text));
// }
// break;
// case "edit":
// break;
// case "copy":
// break;
// case "move":
// break;
// case "share":
// break;
// case "details":
// break;
// }
// }
// }

}
