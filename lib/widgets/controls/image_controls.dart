import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_media_bros_3/widgets/controls/media_controls.dart';
import 'package:super_media_bros_3/widgets/controls/control_group.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';

// TODO Unify this under one class with VideoControls and Audio Controls.
// TODO Use MediaPlayerConfig to pass config into makeControls().
class ImageControls extends StatefulWidget with MediaControls {
  final Function callback;

  // final SuperMediaButtons smb;

  // bool get isPlaying => false;

  ImageControls(this.callback);

  @override
  State createState() => _ImageControlsState();
}

class _ImageControlsState extends State<ImageControls> {
  late SuperMediaButtons smb = SuperMediaButtons(context, widget.callback);

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
      ControlGroup(
          <Widget>[smb.playBtn],
          Position.combine(
            Position.bottomAlign(),
            Position.centerAlign(context, isPlayBtn: true)..top = null,
          )),
      ControlGroup(<IconButton>[smb.prevBtn, smb.nextBtn],
          Position.combine(Position.bottomAlign(), Position.rightAlign())),
      ControlGroup(<IconButton>[smb.favoriteBtn, smb.detailsBtn],
          Position.combine(Position.rightAlign(), Position.topAlign())),
      ControlGroup(<IconButton>[smb.editBtn, smb.shareBtn],
          Position.combine(Position.leftAlign(), Position.bottomAlign())),
      ControlGroup(<IconButton>[smb.moveBtn, smb.copyBtn, smb.deleteBtn],
          Position.combine(Position.topAlign(), Position.leftAlign())),
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
}
