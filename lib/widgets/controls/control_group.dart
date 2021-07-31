import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
import 'package:super_media_bros_3/bloc/media_controller_edit_bloc.dart';
import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/models/position.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';
import 'package:super_media_bros_3/widgets/controls/media_controls.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';

class ControlGroup extends StatefulWidget with SuperMediaWidget {
  get tag => "control-group";
  get isEdit => (key != null && key.toString().contains(MediaControlsState.editTag));

  final Key? key;
  final List<SuperMediaWidget> controlsWidgets;
  final bool horizontal;
  final Position position;

  late final MediaControllerBloc _bloc;

  ControlGroup(this._bloc, this.controlsWidgets, this.position,
      {this.horizontal = true, this.key}); //: ControlGroupState(_bloc, position, horizontal: hroizontal, key: key);

  @override
  State createState() => ControlGroupState(position); //this.controlsWidgets, this.position,
  // horizontal: this.horizontal, key: this.key

  static List<String> makeJsonListFrom(List<ControlGroup> groups) {
    List<String> grpsJson = List.empty(growable: true);
    for (ControlGroup grp in groups) {
      grpsJson.add(json.encode(grp));
    }

    return grpsJson;
  }

  @override
  Map toJson() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['controlsWidgets'] = controlsWidgets;
    map['position'] = position; //.toJson();
    map['horizontal'] = horizontal;

    return map;
  }
}


class ControlGroupState extends State<ControlGroup> {//with SuperMediaWidget {
  get tag => "control-group";
  get isEdit => (widget.key != null
      && widget.key.toString().contains(MediaControlsState.editTag));

  // final Key? key;
  // final List<SuperMediaWidget> controlsWidgets;
  // final bool horizontal;
  Position updatedPosition;
  late final Stream<Position>? streamedPosition;

  ControlGroupState(this.updatedPosition);

  @override
  void didChangeDependencies() {

    // if(isEdit) {
      // MediaControllerEditBloc bloc = (MediaControllerBlocProvider.of(context) as MediaControllerEditBloc);
      //
      // if(bloc.currentGroupEditingKey == this.key) {
      //   Stream positionStream = bloc.updatedGroupPosition;
      //   positionStream.listen((posit) {
      //     position = posit;
      //     setState(() {});
      //   });
      // }

    // }

    super.didChangeDependencies();
  }

  // void positionListener(dynamic position) {
  //   if(position != bloc)
  // }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext innerContext) {
    Widget base = Container(
        padding: EdgeInsets.zero,
        color: isEdit ? MediaOptions.controlGroupBackgroundColor : null,
        child: widget.horizontal
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widget.controlsWidgets,
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widget.controlsWidgets,
              ),
    );

    if (isEdit) {
      // TODO Figure out why this continually returned null.  Despite several efforts
      // TODO aquire from the inherited widget.
      // MediaControllerEditBloc editBloc =
      //     MediaControllerBlocProvider.ofEdit(context);

      MediaControllerEditBloc editBloc = widget._bloc as MediaControllerEditBloc;

      if(editBloc.currentGroupEditingKey == widget.key) {
        editBloc.updatedGroupPosition.listen((posit) {
          log("ControlGroup listener called: posit - ${posit.toString()}");
          updatedPosition = posit;
          // setState(() {
          //   position = posit;
          // });
        });
      }

      base = LongPressDraggable(
        child: base,
        feedback: widget.highlightDragging(),
        onDragUpdate: editBloc.updateData,
        onDragStarted: () => editBloc.currentGroupEditing = this.widget,
        data: ControlGroup(
            widget._bloc, widget.controlsWidgets, updatedPosition,
            horizontal: widget.horizontal, key: widget.key),
      );
    }

    return Positioned(
      key: widget.key,
      child: base,
      left: widget.position.left,
      top: widget.position.top,
      right: widget.position.right,
      bottom: widget.position.bottom,
    );
  }

  // static ControlGroup fromMap(Map<String, dynamic> map, SuperMediaButtons smb, {Key? key}) {
  //   return ControlGroup(
  //     makeWidgets(map['controlsWidgets'], smb),
  //     Position.fromJson(map['positions']),
  //     horizontal: map['horizontal'],
  //     key: key,
  //   );
  // }

  // static ControlGroup fromJson(String json, SuperMediaButtons smb, {Key? key}) {
  //   Map<String, dynamic> map = jsonDecode(json);
  //
  //   return ControlGroup(
  //     makeWidgets(map['controlsWidgets'], smb),
  //     Position.fromJson(map['position']),
  //     horizontal: map['horizontal'],
  //     key: key,
  //   );
  // }

  // static List<SuperMediaWidget> makeWidgets(List<dynamic> maps, SuperMediaButtons smb) {
  //   List<SuperMediaWidget> widgets = List.empty(growable: true);
  //
  //   for(Map map in maps) {
  //     widgets.add(smb.fromTag(map['tag']));
  //   }
  //
  //   return widgets;
  // }


}
