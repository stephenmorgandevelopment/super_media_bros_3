import 'package:flutter/material.dart';
import 'package:super_media_bros_3/mediaplayer/media_controls_config.dart';
import 'package:super_media_bros_3/models/position.dart';
import 'package:super_media_bros_3/widgets/controls/media_controls.dart';
import 'package:super_media_bros_3/widgets/controls/control_group.dart';
import 'package:super_media_bros_3/widgets/controls/custom_sliders.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';

class VideoControls extends MediaControls {
  VideoControls(Function(String tag) callback, {Key? key, bool isEdit = false})
      : super(callback, key: key, isEdit: isEdit);

  @override
  State createState() => _VideoControlsState();
}

class _VideoControlsState extends MediaControlsState<VideoControls> {
  @override
  List<String> get asJson => MediaControls.jsonListFromGroups(
      makeControls(MediaControlsConfig.videoControlsAsJson));

  @override
  Widget build(BuildContext innerContext) {
    return Container(
      child: Material(
        elevation: 64.0,
        child: Stack(
          fit: StackFit.passthrough,
          children: makeControls(MediaControlsConfig.videoControlsAsJson),
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
      ControlGroup(bloc, <SuperMediaWidget>[smb.videoPlayBtn],
          Position.centerAlign(context, isPlayBtn: true)),
      ControlGroup(bloc, <SuperMediaWidget>[smb.seekBackBtn, smb.seekFwdBtn],
          Position(bottom: 56.0, right: 20.0)),
      ControlGroup(bloc, <SuperMediaWidget>[smb.prevBtn, smb.nextBtn],
          Position.combine(Position.topAlign(), Position.rightAlign())),
      ControlGroup(bloc, <SuperMediaWidget>[smb.speedBtn, smb.detailsBtn],
          Position(bottom: 56.0, left: 20.0)),
      ControlGroup(bloc, <SuperMediaWidget>[TimeSlider()],
          Position(bottom: 12.0, left: 10.0, right: 10.0)),
    ];
  }
}
