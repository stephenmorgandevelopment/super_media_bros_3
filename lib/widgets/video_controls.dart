import 'package:flutter/material.dart';
import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/mediaplayer/media_player_config.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/widgets/media_controls.dart';
import 'package:super_media_bros_3/widgets/control_group.dart';
import 'package:super_media_bros_3/widgets/video_view.dart';
import 'package:video_player/video_player.dart';
import 'package:super_media_bros_3/widgets/super_media_buttons.dart';


// TODO Unify this under one class with ImageControls and Audio Controls.
// TODO Use MediaPlayerConfig to pass config into makeControls().
class VideoControls extends StatefulWidget with MediaControls {
  // final Function callback;
  // final VideoPlayerController controller;
  // final BuildContext context;
  final SuperMediaButtons smb;

  // VideoControls(this.context, this.callback);
  VideoControls(this.smb);

  @override
  State<StatefulWidget> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  // late SuperMediaButtons smb = SuperMediaButtons(context, onPressed);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: makeControls(),
      constraints: BoxConstraints.expand(),
      // color: Color.fromARGB(90, 80, 80, 80),
      alignment: Alignment.center,
    );
  }

  // TODO Pull controls config from MediaPlayerConfig.
  Widget makeControls() {
    List<ControlGroup> groups = <ControlGroup>[
      ControlGroup(<IconButton>[widget.smb.videoPlayBtn], alignment: Alignment.center),
      ControlGroup(<IconButton>[widget.smb.seekBackBtn, widget.smb.seekFwdBtn],
          alignment: Alignment.bottomRight),
      ControlGroup(<IconButton>[widget.smb.prevBtn, widget.smb.nextBtn],
          alignment: Alignment.topRight),
      ControlGroup(<IconButton>[widget.smb.speedBtn, widget.smb.detailsBtn],
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

  // void onPressed(String btnTag) => widget.callback(btnTag);
}
