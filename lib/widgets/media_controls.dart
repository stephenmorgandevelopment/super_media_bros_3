import 'package:flutter/material.dart';
import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/mediaplayer/media_player_config.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/widgets/control_group.dart';
import 'package:video_player/video_player.dart';
import 'package:super_media_bros_3/widgets/super_media_buttons.dart';

class MediaControls extends StatefulWidget {
  Function callback;
  final VideoPlayerController controller;

  MediaControls(this.controller, this.callback);

  @override
  State<StatefulWidget> createState() => _MediaControlsState();
}

class _MediaControlsState extends State<MediaControls> {
  late SuperMediaButtons smb;
  
  @override
  Widget build(BuildContext context) {
    smb = SuperMediaButtons(context, onPressed);
    
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
      ControlGroup(<IconButton>[smb.playBtn], alignment: Alignment.center),
      ControlGroup(<IconButton>[smb.seekBackBtn, smb.seekFwdBtn],
          alignment: Alignment.bottomRight),
      ControlGroup(<IconButton>[smb.prevBtn, smb.nextBtn],
          alignment: Alignment.topRight),
      ControlGroup(<IconButton>[smb.speedBtn, smb.detailsBtn],
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

  void onPressed(String btnTag) => widget.callback(btnTag);
}
