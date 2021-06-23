import 'package:flutter/material.dart';
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
      ControlGroup(
          <IconButton>[prevBtn, nextBtn], alignment: Alignment.topRight),
      ControlGroup(
          <IconButton>[speedBtn, detailsBtn], alignment: Alignment.bottomLeft),
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
        if(widget.controller.value.isPlaying) {
          widget.controller.pause();
        } else {
          widget.controller.play();
        }
        setState(() {});
        break;
      case "seek-fwd":
        int curPos = (await widget.controller.position)?.inMilliseconds ?? 0;
        Duration newPos = Duration(milliseconds: (curPos + MediaOptions.seekForwardTime));
        widget.controller.seekTo(newPos);
        break;
      case "seek-back":
        int curPos = (await widget.controller.position)?.inMilliseconds ?? 0;
        Duration newPos = Duration(milliseconds: (curPos - MediaOptions.seekBackwardsTime));
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

  IconButton get playBtn =>
      IconButton(
          onPressed: () => onPressed("play-pause"),
          iconSize: MediaOptions.iconsize * 2.5,
          icon: Icon(
            widget.controller.value.isPlaying
                ? Icons.pause_circle_filled_outlined
                : Icons.play_circle_fill_outlined,
            color: Colors.white38,
            semanticLabel: "Play or pause the video.",
          ));

  IconButton get speedBtn =>
      IconButton(
          onPressed: () => onPressed("speed"),
          iconSize: MediaOptions.iconsize,
          icon: Icon(
            Icons.slow_motion_video_outlined,
            color: Colors.white38,
            semanticLabel: "Adjust playback speed of the video.",
          ));

  IconButton get prevBtn =>
      IconButton(
          onPressed: () => onPressed("prev"),
          iconSize: MediaOptions.iconsize,
          icon: Icon(
            Icons.skip_previous_outlined,
            color: Colors.white38,
            semanticLabel: "Previous video.",
          ));

  IconButton get seekBackBtn =>
      IconButton(
          onPressed: () => onPressed("seek-back"),
          iconSize: MediaOptions.iconsize,
          icon: Icon(
            Icons.fast_rewind_outlined,
            color: Colors.white38,
            semanticLabel: "Seek backwards in the video.",
          ));

  IconButton get seekFwdBtn =>
      IconButton(
          onPressed: () => onPressed("seek-fwd"),
          iconSize: MediaOptions.iconsize,
          icon: Icon(
            Icons.fast_forward_outlined,
            color: Colors.white38,
            semanticLabel: "Seek forward in the video.",
          ));

  IconButton get nextBtn =>
      IconButton(
          onPressed: () => onPressed("next"),
          iconSize: MediaOptions.iconsize,
          icon: Icon(
            Icons.skip_next_outlined,
            color: Colors.white38,
            semanticLabel: "Next video.",
          ));

  IconButton get detailsBtn =>
      IconButton(
          onPressed: () => onPressed("details"),
          iconSize: MediaOptions.iconsize,
          icon: Icon(
            Icons.info_outlined,
            color: Colors.white38,
            semanticLabel: "View details about the video.",
          ));
}
