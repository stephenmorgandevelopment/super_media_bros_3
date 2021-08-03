

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
import 'package:super_media_bros_3/bloc/media_controller_edit_bloc.dart';
import 'package:super_media_bros_3/mediaplayer/media_controls_config.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/widgets/controls/control_group.dart';

class MenuHeaderBloc {
  final MediaControllerBloc _blocCached;
  Type get _type => _blocCached.type;

  List<String>? get _controlGroupsJson => isEdit ? _bloc.controlGroupsJson : null;

  dynamic get _bloc => isEdit
      ? _blocCached as MediaControllerEditBloc
      : _blocCached;

  bool isEdit;

  MenuHeaderBloc(this._blocCached, {this.isEdit = false});

  Future<void> resetDefault() async {
    if(!isEdit) {
      return;
    }

    MediaControlsConfig.clearJson(_type);
    log("clearing json for _type");

    List<ControlGroup> genericGroups = _bloc.controlsKey?.currentState?.makeGeneric();
    MediaControlsConfig.updateJson(_type, ControlGroup.makeJsonListFrom(genericGroups));
    _bloc.refreshViews();
  }

  Future<void> saveLayout() async {
    if(!isEdit) {
      return;
    }
    return MediaControlsConfig.updateJson(_type, _controlGroupsJson!);
  }

  void addMediaButton() {

  }

  void addControlGroup() {

  }
}