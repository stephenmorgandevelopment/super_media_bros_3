import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
import 'package:super_media_bros_3/bloc/media_controller_edit_bloc.dart';
import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/models/position.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';
import 'package:super_media_bros_3/widgets/controls/media_controls.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';

class ControlGroup extends StatefulWidget with SuperMediaWidget {
  get tag => "control-group";

  get isEdit =>
      (key != null && key.toString().contains(MediaControlsState.editTag));

  final Key? key;
  final List<SuperMediaWidget> controlsWidgets;
  final bool horizontal;
  final Position position;

  late final MediaControllerBloc _bloc;

  ControlGroup(this._bloc, this.controlsWidgets, this.position,
      {this.horizontal = true,
      this.key}); //: ControlGroupState(_bloc, position, horizontal: hroizontal, key: key);

  @override
  State createState() =>
      ControlGroupState(); //this.controlsWidgets, this.position,
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

class ControlGroupState extends State<ControlGroup> {
  //with SuperMediaWidget {
  get tag => "control-group";

  get isEdit => (widget.key != null &&
      widget.key.toString().contains(MediaControlsState.editTag));

  bool dragging = false;

  MediaControllerEditBloc? get editBloc =>
      isEdit ? widget._bloc as MediaControllerEditBloc : null;

  ControlGroupState();

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

  @override
  void dispose() {
    super.dispose();
  }

  get editBackgroundColor => dragging
      ? MediaOptions.dragHighlightColor
      : MediaOptions.controlGroupBackgroundColor;

  @override
  Widget build(BuildContext innerContext) {
    Widget base = Material(
      type: MaterialType.transparency,
      child: Container(
        padding: EdgeInsets.zero,
        // color: isEdit ? MediaOptions.controlGroupBackgroundColor : null,
        color: isEdit ? editBackgroundColor : null,
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
      ),
    );

    if (isEdit) {
      return wrap(LongPressDraggable(
        child: base,
        feedback: base,
        onDragEnd: _dropped,
        onDragStarted: startDrag,
        data: widget,
      ));
    }

    return wrap(base);
  }

  void startDrag() {
    editBloc!.currentGroupEditing = widget;
    dragging = true;
  }

  _dropped(DraggableDetails details) {
    dragging = false;
    editBloc?.sinkOffset(details);
  }

  wrap(Widget needsWrapped) {
    return Positioned(
      key: widget.key,
      child: needsWrapped,
      left: widget.position.left,
      top: widget.position.top,
      right: widget.position.right,
      bottom: widget.position.bottom,
    );
  }
}
