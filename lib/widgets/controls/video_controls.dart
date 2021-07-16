import 'package:flutter/material.dart';
import 'package:super_media_bros_3/widgets/controls/media_controls.dart';
import 'package:super_media_bros_3/widgets/controls/control_group.dart';
import 'package:super_media_bros_3/widgets/time_slider.dart';
import 'package:super_media_bros_3/widgets/super_media_buttons.dart';

// TODO Unify this under one class with ImageControls and Audio Controls.
// TODO Use MediaPlayerConfig to pass config into makeControls().
class VideoControls extends StatefulWidget with MediaControls {
  final Function callback;

  // final VideoPlayerController controller;
  // final BuildContext context;
  // final SuperMediaButtons smb;

  // VideoControls(this.context, this.callback);
  const VideoControls(this.callback);

  @override
  State<StatefulWidget> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  late SuperMediaButtons smb = SuperMediaButtons(context, widget.callback);

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
      ControlGroup(<IconButton>[smb.videoPlayBtn], alignment: Alignment.center),
      ControlGroup(
        <IconButton>[smb.seekBackBtn, smb.seekFwdBtn],
        alignment: Alignment.bottomRight,
        margins: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 70.0),
      ),
      ControlGroup(<IconButton>[smb.prevBtn, smb.nextBtn],
          alignment: Alignment.topRight),
      ControlGroup(
        <IconButton>[smb.speedBtn, smb.detailsBtn],
        alignment: Alignment.bottomLeft,
        margins: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 70.0),
      ),
      ControlGroup(
        <Widget>[TimeSlider()],
        alignment: Alignment.bottomCenter,
        margins: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
      ),
    ];

    // List<Widget> controlWidgets = List.empty(growable: true);
    // for (ControlGroup group in groups) {
    //   controlWidgets.add(group.compose());
    // }

    return Material(
      elevation: 7.0,
      child: Stack(
        fit: StackFit.passthrough,
        children: groups,
      ),
      type: MaterialType.transparency,
    );
  }

// void onPressed(String btnTag) => widget.callback(btnTag);
}
