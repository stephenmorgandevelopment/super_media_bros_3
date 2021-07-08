

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_media_bros_3/widgets/media_controls.dart';
import 'package:super_media_bros_3/widgets/control_group.dart';
import 'package:super_media_bros_3/widgets/super_media_buttons.dart';

// TODO Unify this under one class with VideoControls and Audio Controls.
// TODO Use MediaPlayerConfig to pass config into makeControls().
class ImageControls extends StatefulWidget with MediaControls {
  // final Function callback;
  final SuperMediaButtons smb;

  // bool get isPlaying => false;

  ImageControls(this.smb);

  @override
  State createState() => _ImageControlsState();
}

class _ImageControlsState extends State<ImageControls> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: makeControls(),
      constraints: BoxConstraints.expand(),
      alignment: Alignment.center,
    );
  }

  Widget makeControls() {
    List<ControlGroup> groups = <ControlGroup>[
      ControlGroup(<IconButton>[widget.smb.playBtn],
          alignment: Alignment.bottomCenter),
      ControlGroup(<IconButton>[widget.smb.prevBtn, widget.smb.nextBtn],
          alignment: Alignment.bottomRight),
      ControlGroup(<IconButton>[widget.smb.favoriteBtn, widget.smb.detailsBtn],
          alignment: Alignment.topRight),
      ControlGroup(<IconButton>[widget.smb.editBtn, widget.smb.shareBtn],
          alignment: Alignment.bottomLeft),
      ControlGroup(<IconButton>[widget.smb.moveBtn, widget.smb.copyBtn, widget.smb.deleteBtn],
          alignment: Alignment.topLeft),
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
}