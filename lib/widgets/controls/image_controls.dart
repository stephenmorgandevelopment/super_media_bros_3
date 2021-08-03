import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_media_bros_3/mediaplayer/media_controls_config.dart';
import 'package:super_media_bros_3/models/position.dart';
import 'package:super_media_bros_3/widgets/controls/media_controls.dart';
import 'package:super_media_bros_3/widgets/controls/control_group.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';

class ImageControls extends MediaControls {
  ImageControls(Function(String tag) callback, {Key? key, bool isEdit = false})
      : super(callback, key: key, isEdit: isEdit);

  @override
  State createState() => _ImageControlsState();
}

class _ImageControlsState extends MediaControlsState<ImageControls> {
  @override
  List<String> get asJson => MediaControls.jsonListFromGroups(
      makeControls(MediaControlsConfig.imageControlsAsJson));

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        elevation: 64.0,
        child: Stack(
          fit: StackFit.passthrough,
          children: makeControls(MediaControlsConfig.imageControlsAsJson),
        ),
        type: MaterialType.transparency,
      ),
      constraints: BoxConstraints.expand(),
      alignment: Alignment.center,
    );
  }

  @override
  List<ControlGroup> makeGeneric() {
    return <ControlGroup>[
      ControlGroup(
          bloc,
          <SuperMediaWidget>[smb.playBtn],
          Position.combine(Position.bottomAlign(),
              Position.centerAlign(context, isPlayBtn: true)..top = null)),
      ControlGroup(bloc, <SuperMediaWidget>[smb.prevBtn, smb.nextBtn],
          Position.combine(Position.bottomAlign(), Position.rightAlign())),
      ControlGroup(bloc, <SuperMediaWidget>[smb.favoriteBtn, smb.detailsBtn],
          Position.combine(Position.rightAlign(), Position.topAlign())),
      ControlGroup(bloc, <SuperMediaWidget>[smb.editBtn, smb.shareBtn],
          Position.combine(Position.leftAlign(), Position.bottomAlign())),
      ControlGroup(
          bloc,
          <SuperMediaWidget>[smb.moveBtn, smb.copyBtn, smb.deleteBtn],
          Position.combine(Position.topAlign(), Position.leftAlign()))
    ];
  }
}
