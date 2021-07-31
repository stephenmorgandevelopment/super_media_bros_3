import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
import 'package:super_media_bros_3/bloc/media_controller_edit_bloc.dart';
import 'package:super_media_bros_3/mediaplayer/media_controls_config.dart';
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
  Widget build(BuildContext innerContext) {
    if (widget.isEdit) {
      return StreamBuilder(
          // return Container(
          //   child: Material(
          //     elevation: 7.0,
          //     child: StreamBuilder(
          stream: editBloc.updatedGroupPosition,
          builder:
              (BuildContext innaInnContext, AsyncSnapshot<Position> snapshot) {
            List<ControlGroup> controlGroups =
                makeControls(MediaControlsConfig.videoControlsAsJson);

            // if (widget.isEdit) {
            //   editBloc.setCurrentGroupEditing();
            editBloc.currentGroupEditing?.highlightDragging();

            if (snapshot.hasData) {
              ControlGroup editing = editBloc.currentGroupEditing!;

              ControlGroup updatedGroup = ControlGroup(
                editBloc,
                editing.controlsWidgets,
                snapshot.data!,
                horizontal: editing.horizontal,
                key: editing.key,
              );

              // if (controlGroups.remove(editBloc.currentGroupEditing!)) {
              //   controlGroups.add(updatedGroup);
              //   // editBloc.setCurrentGroupEditing();
              //   log("Dart isn't complete trash...${editBloc.currentGroupEditing!} was removed successfully.");
              // }
            }
            // }

            return Container(
              // color: MediaOptions.controlGroupBackgroundColor,
              child: Material(
                elevation: 64.0,
                child: Stack(
                  fit: StackFit.passthrough,
                  children: controlGroups,
                ),
                type: MaterialType.transparency,
              ),
              constraints: BoxConstraints.expand(),
              // color: Color.fromARGB(90, 80, 80, 80),
              alignment: Alignment.center,
            );
          });
    } else {
      return Container(
        // color: MediaOptions.controlGroupBackgroundColor,
        child: Material(
          elevation: 64.0,
          child: Stack(
            fit: StackFit.passthrough,
            // fit: StackFit.expand,
            children: makeControls(MediaControlsConfig.videoControlsAsJson),
          ),
          type: MaterialType.transparency,
        ),
        constraints: BoxConstraints.expand(),
        // color: Color.fromARGB(90, 80, 80, 80),
        alignment: Alignment.center,
      );
    }
  }

  void highlightSelectedGroup() {}

  // void update() {
  //   setState(() {
  //
  //   });
  // }

  @override
  List<String> get asJson => MediaControls.jsonListFromGroups(
      makeControls(MediaControlsConfig.videoControlsAsJson));

  @override
  List<ControlGroup> makeGeneric() {
    MediaControllerBloc bloc = MediaControllerBlocProvider.of(context);

    return <ControlGroup>[
      ControlGroup(
        bloc,
        <SuperMediaWidget>[smb.videoPlayBtn],
        Position.centerAlign(context, isPlayBtn: true),
      ),
      ControlGroup(
        bloc,
        <SuperMediaWidget>[smb.seekBackBtn, smb.seekFwdBtn],
        Position(bottom: 56.0, right: 20.0),
      ),
      ControlGroup(bloc, <SuperMediaWidget>[smb.prevBtn, smb.nextBtn],
          Position.combine(Position.topAlign(), Position.rightAlign())),
      ControlGroup(
        bloc,
        <SuperMediaWidget>[smb.speedBtn, smb.detailsBtn],
        Position(bottom: 56.0, left: 20.0),
      ),
      ControlGroup(
        bloc,
        <SuperMediaWidget>[TimeSlider()],
        Position(bottom: 12.0, left: 10.0, right: 10.0),
      ),
    ];
  }
}
