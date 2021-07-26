import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
import 'package:super_media_bros_3/mediaplayer/media_controls_config.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/models/position.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';
import 'package:super_media_bros_3/widgets/controls/media_controls.dart';
import 'package:super_media_bros_3/widgets/controls/control_group.dart';
import 'package:super_media_bros_3/widgets/controls/custom_sliders.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';

// TODO Unify this under one class with ImageControls and Audio Controls.
// TODO Use MediaPlayerConfig to pass config into makeControls().
class VideoControls extends MediaControls {
  // get _callback => callback;

  VideoControls(Function(String tag) callback, {Key? key, bool isEdit = false})
      : super(callback, key: key, isEdit: isEdit);

  @override
  State createState() => _VideoControlsState();
}

class _VideoControlsState extends MediaControlsState<VideoControls> {
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Material(
        elevation: 7.0,
        child: Stack(
          fit: StackFit.passthrough,
          // fit: StackFit.expand,
          children: makeControls(),
        ),
        type: MaterialType.transparency,
      ),
      constraints: BoxConstraints.expand(),
      // color: Color.fromARGB(90, 80, 80, 80),
      alignment: Alignment.center,
    );
  }

  // TODO Pull controls config from MediaPlayerConfig.
  @override
  List<ControlGroup> makeControls() {
    List<String> groupsJson = MediaControlsConfig.videoControlsAsJson;
    List<ControlGroup> grps = List.empty(growable: true);

    if (groupsJson.isNotEmpty) {
      int groupIndex = 0;
      for (String json in groupsJson) {
        Key? key = widget.isEdit ? Key("edit-group${groupIndex++}") : null;
        grps.add(ControlGroup.fromJson(json, smb, key: key));
      }
    } else {
      grps = makeGeneric();
      List<String> grpsJson = List.empty(growable: true);
      for (ControlGroup grp in grps) {
        grpsJson.add(json.encode(grp));
        log("grp encoded ${grp.toString()}");
      }

      MediaControlsConfig.updateJson(Type.VIDEO, grpsJson);
    }

    if(widget.isEdit) {
      var bloc = MediaControllerBlocProvider.ofEdit(context);
      bloc.controlGroups.clear();
      bloc.controlGroups.addAll(grps);
    }

    return grps;
  }

  List<ControlGroup> makeGeneric() {
    return <ControlGroup>[
      ControlGroup(
        <SuperMediaWidget>[smb.videoPlayBtn],
        Position.centerAlign(context, isPlayBtn: true),
      ),
      ControlGroup(
        <SuperMediaWidget>[smb.seekBackBtn, smb.seekFwdBtn],
        Position(bottom: 56.0, right: 20.0),
      ),
      ControlGroup(<SuperMediaWidget>[smb.prevBtn, smb.nextBtn],
          Position.combine(Position.topAlign(), Position.rightAlign())),
      ControlGroup(
        <SuperMediaWidget>[smb.speedBtn, smb.detailsBtn],
        Position(bottom: 56.0, left: 20.0),
      ),
      ControlGroup(
        <SuperMediaWidget>[TimeSlider()],
        Position(bottom: 12.0, left: 10.0, right: 10.0),
      ),
    ];
  }
}
