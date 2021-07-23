import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
import 'package:super_media_bros_3/models/position.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';
import 'package:super_media_bros_3/widgets/controls/media_controls.dart';
import 'package:super_media_bros_3/widgets/controls/control_group.dart';
import 'package:super_media_bros_3/widgets/controls/custom_sliders.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';

// TODO Unify this under one class with ImageControls and Audio Controls.
// TODO Use MediaPlayerConfig to pass config into makeControls().
class VideoControls extends StatefulWidget with MediaControls {
  final Function callback;

  VideoControls(this.callback);

  @override
  State createState() => _VideoControlsState();



// TODO Understand why this doesn't work:
  // static VideoControls from(SuperMediaButtons smb) {
  //   var controls = VideoControls(smb.onPressed);
  //   controls.createState(smb: smb);
  //   return controls;
  // }

// TODO Understand why this doesn't work:
  // @override
  // State<StatefulWidget> createState({SuperMediaButtons? smb}) =>
  //     smb == null ? _VideoControlsState() : _VideoControlsState.using(smb);


}

class _VideoControlsState extends State<VideoControls> {
  late SuperMediaButtons smb = SuperMediaButtons(context, widget.callback);
  late List<ControlGroup> groups;

  // TODO help???:
  Map toJson() {
    Map<String, dynamic> map = new Map<String, dynamic>();

    map['controls'] = jsonEncode(
        groups,
        toEncodable: (dynamic grps) => grps!.toJson());

    log("VideoControls mapped: ${map.toString()}");
    return map;
  }

  // TODO help???:
  @override
  void didChangeDependencies() {
    groups = makeControls();
    MediaControllerBlocProvider.of(context).json = jsonEncode(this);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // smb = SuperMediaButtons(context, widget.callback);
    // groups = makeControls();

    // widget.json = jsonEncode(groups);



    return Container(
      child: Material(
      elevation: 7.0,
      child: Stack(
        fit: StackFit.passthrough,
        // fit: StackFit.expand,
        children: groups,
      ),
      type: MaterialType.transparency,
    ),
      constraints: BoxConstraints.expand(),
      // color: Color.fromARGB(90, 80, 80, 80),
      alignment: Alignment.center,
    );
  }

  // TODO Pull controls config from MediaPlayerConfig.
  List<ControlGroup> makeControls() {
    // List<ControlGroup> groups = <ControlGroup>[
    return <ControlGroup>[
      ControlGroup(
        <SuperMediaWidget>[smb.videoPlayBtn],
        Position.centerAlign(context, isPlayBtn: true),
      ),
      ControlGroup(
        <SuperMediaWidget>[smb.seekBackBtn, smb.seekFwdBtn],
        Position(bottom: 56.0, right: 20.0),
        // Position.combine(Position.bottomAlign(), Position.rightAlign()),
        // margins: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 70.0),
      ),
      ControlGroup(<SuperMediaWidget>[smb.prevBtn, smb.nextBtn],
          Position.combine(Position.topAlign(), Position.rightAlign())),
      ControlGroup(
        <SuperMediaWidget>[smb.speedBtn, smb.detailsBtn],
        Position(bottom: 56.0, left: 20.0),
        // margins: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 70.0),
      ),
      ControlGroup(
        <SuperMediaWidget>[TimeSlider()],
        Position(bottom: 12.0, left: 10.0, right: 10.0),
        // margins: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
      ),
    ];



    // return MediaQuery(
    //   data: MediaQuery.of(context),
    //   child: Material(
    //     elevation: 7.0,
    //     child: Stack(
    //       fit: StackFit.passthrough,
    //       children: groups,
    //     ),
    //     type: MaterialType.transparency,
    //   ),
    // );
  }

// void onPressed(String btnTag) => widget.callback(btnTag);
}
