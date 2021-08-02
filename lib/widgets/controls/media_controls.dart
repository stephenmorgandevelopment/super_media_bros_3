import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
import 'package:super_media_bros_3/bloc/media_controller_edit_bloc.dart';
import 'package:super_media_bros_3/mediaplayer/media_controls_config.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/models/position.dart';
import 'package:super_media_bros_3/widgets/controls/control_group.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';

abstract class MediaControls extends StatefulWidget {
  @protected
  final Function(String tag) callback;
  final bool isEdit;
  final Key? key;

  MediaControls(this.callback, {this.key, this.isEdit = false})
      : super();

  static List<String> jsonListFromGroups(List<ControlGroup> groups) {
    List<String> grpsJson = List.empty(growable: true);
    for (ControlGroup grp in groups) {
      grpsJson.add(json.encode(grp));
      // log("grp encoded ${grp.toString()}");
    }

    return grpsJson;
  }
}

abstract class MediaControlsState<T extends MediaControls> extends State<T> {
  static final String editTag = "edit-group";
  late MediaControllerBloc _bloc;
  MediaControllerBloc get bloc => _bloc;
  MediaControllerEditBloc get editBloc => _bloc as MediaControllerEditBloc;

  @protected
  late SuperMediaButtons smb;

  @override
  void didChangeDependencies() {
    _bloc = MediaControllerBlocProvider.of(context);
    if(widget.isEdit) {
      editBloc.refreshStream.listen((_) => setState(() {

      }));
    }

    super.didChangeDependencies();
  }

  List<ControlGroup> makeControls(List<String> groupsJson) {
    smb = SuperMediaButtons(context, widget.callback);
    List<ControlGroup> grps = List.empty(growable: true);

    if (groupsJson.isNotEmpty) {
      int groupIndex = 0;
      for (String json in groupsJson) {
        Key? key = widget.isEdit
            ? Key("${MediaControlsState.editTag}${groupIndex++}") : null;

        grps.add(makeControlGroup(json, key: key));
      }
    } else {
      grps = genericGroups;
      MediaControlsConfig.updateJson(
          _bloc.bloc.type!,
          MediaControls.jsonListFromGroups(grps));
    }

    if (widget.isEdit) {
      editBloc.controlGroups = grps;
    }

    return grps;
  }

  List<ControlGroup> get genericGroups => makeGeneric();
  makeGeneric();
  List<String> get asJson;

  ControlGroup makeControlGroup(String jsonString,
      {Key? key}) {
    Map<String, dynamic> map = jsonDecode(jsonString);

    return ControlGroup(_bloc,
      makeWidgets(map['controlsWidgets']),
      Position.fromJson(map['position']),
      horizontal: map['horizontal'],
      key: key,
    );
  }

  List<SuperMediaWidget> makeWidgets(List<dynamic> maps) {
    List<SuperMediaWidget> widgets = List.empty(growable: true);

    // MediaControllerEditBloc? _editBloc = widget.isEdit ?
    //   MediaControllerBlocProvider.of(context) as MediaControllerEditBloc :
    //   null;

    for (Map map in maps) {
      SuperMediaWidget controlsWidget = smb.fromTag(map['tag']);
      widgets.add(controlsWidget);

      if (widget.isEdit && map['tag'] == editBloc.currentButtonEditingTag) {
        controlsWidget.highlightSelected();
      }
    }

    return widgets;
  }

  Map toJson() {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map['controls'] =
        makeControls(
            MediaControlsConfig.controlsAsJsonByType(_bloc.bloc.type!));

    return map;
  }
}
