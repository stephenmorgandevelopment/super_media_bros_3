import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_media_bros_3/mediaplayer/media_controls_config.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/models/position.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';
import 'package:super_media_bros_3/widgets/controls/media_controls.dart';
import 'package:super_media_bros_3/widgets/controls/control_group.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';

// TODO Unify this under one class with VideoControls and Audio Controls.
// TODO Use MediaPlayerConfig to pass config into makeControls().
class ImageControls extends MediaControls {
  get _callback => callback;

  ImageControls(Function(String tag) callback, {Key? key, bool isEdit = false})
      : super(callback, key: key, isEdit: isEdit);

  @override
  State createState() => _ImageControlsState();
}

class _ImageControlsState extends MediaControlsState<ImageControls> {
  // late SuperMediaButtons smb;

  @override
  void didChangeDependencies() {
    // smb = SuperMediaButtons(context, widget._callback);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // groups = makeControls();

    return Container(
      child: Material(
        elevation: 7.0,
        child: Stack(
          fit: StackFit.passthrough,
          children: makeControls(),
        ),
        type: MaterialType.transparency,
      ),
      constraints: BoxConstraints.expand(),
      alignment: Alignment.center,
    );
  }

  @override
  List<ControlGroup> makeControls() {
    List<String> groupsJson = MediaControlsConfig.imageControlsAsJson;
    List<ControlGroup> grps;
    if(groupsJson.isNotEmpty) {
      grps = List.empty(growable: true);
      log("Images groupsJson = ${groupsJson.join('\n')}");

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
      MediaControlsConfig.updateJson(Type.IMAGE, grpsJson);
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
          <SuperMediaWidget>[smb.playBtn],
          Position.combine(
            Position.bottomAlign(),
            Position.centerAlign(context, isPlayBtn: true)..top = null,
          )),
      ControlGroup(<SuperMediaWidget>[smb.prevBtn, smb.nextBtn],
          Position.combine(Position.bottomAlign(), Position.rightAlign())),
      ControlGroup(<SuperMediaWidget>[smb.favoriteBtn, smb.detailsBtn],
          Position.combine(Position.rightAlign(), Position.topAlign())),
      ControlGroup(<SuperMediaWidget>[smb.editBtn, smb.shareBtn],
          Position.combine(Position.leftAlign(), Position.bottomAlign())),
      ControlGroup(<SuperMediaWidget>[smb.moveBtn, smb.copyBtn, smb.deleteBtn],
          Position.combine(Position.topAlign(), Position.leftAlign())),
    ];
  }
}
