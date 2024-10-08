import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
import 'package:super_media_bros_3/main.dart';
import 'package:super_media_bros_3/mediaplayer/media_controls_config.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/models/position.dart';
import 'package:super_media_bros_3/widgets/controls/control_group.dart';
import 'package:super_media_bros_3/widgets/controls/media_controls.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';

class MediaControllerEditBloc implements MediaControllerBloc {
  late MediaBloc bloc;
  late Future<void> initializeControllerFuture;

  Type get type => bloc.type!;

  MediaControllerEditBloc(this.bloc) {
    initializeControllerFuture = initController();
  }

  GlobalKey<MediaControlsState>? controlsKey;

  List<String> get controlGroupsJson =>
      ControlGroup.makeJsonListFrom(_controlGroups);

  BehaviorSubject<List<String>> _controlsJsonSubject =
      BehaviorSubject<List<String>>();

  Stream<List<String>> get controlsJsonStringStream =>
      _controlsJsonSubject.stream;

  void sinkControlsJson() {
    _controlsJsonSubject.sink.add(controlGroupsJson);
    MediaControlsConfig.updateJson(type, controlGroupsJson);
    log("sinkControlsJson called with $controlGroupsJson");
    refreshViews();
  }

  BehaviorSubject _refreshSubject = BehaviorSubject();
  Stream get refreshStream => _refreshSubject.stream.asBroadcastStream();
  void refreshViews() => _refreshSubject.sink.add(true);

  List<ControlGroup> _controlGroups = List.empty(growable: true);
  List<ControlGroup> get controlGroups => _controlGroups;
  set controlGroups(List<ControlGroup> groups) {
    _controlGroups.clear();
    _controlGroups.addAll(groups);
  }

  void replaceControlGroupWithUpdated(ControlGroup controlGroup) {
    if (_controlGroups.remove(currentGroupEditing)) {
      log("currentEditingGroup was removed: $controlGroup");
      _controlGroups.add(controlGroup);
    } else {
      log("Dart failed us removing: $controlGroup\n Zero surprise..fixing manually.");
      if (manuallyReplaceControlGroupWithUpdated(controlGroup)) {
        log("$currentGroupEditing was removed manually: $controlGroup");
      }
    }

    sinkControlsJson();
  }

  bool manuallyReplaceControlGroupWithUpdated(ControlGroup controlGroup) {
    bool successful = false;
    for (ControlGroup group in controlGroups) {
      if (group.key.toString() == currentGroupEditing!.key.toString()) {
        successful = controlGroups.remove(group);
        break;
      }
    }
    return successful;
  }

  String currentButtonEditingTag = 'null';
  SuperMediaButton? currentButtonEditing;

  Key? get currentGroupEditingKey => currentGroupEditing?.key;
  ControlGroup? currentGroupEditing;

  final ReplaySubject<Offset> _offsetSubject = ReplaySubject<Offset>();
  void sinkOffset(DraggableDetails details) {
    log("offsetSubject updated: ${details.toString()}");
    _offsetSubject.sink.add(details.offset);
  }

  Stream<ControlGroup> get droppedUpdatedControlGroup =>
      _offsetSubject.stream.map<ControlGroup>((globalOffset) {
        log('AppGlobals.statusbarHeight: ${AppGlobals.statusBarHeight}');
        return ControlGroup(
          this,
          currentGroupEditing!.controlsWidgets,
          Position(
              top: globalOffset.dy - AppGlobals.statusBarHeight,
              left: globalOffset.dx),
          horizontal: currentGroupEditing!.horizontal,
          key: currentGroupEditing!.key,
        );
      });

  bool get isPlaying => true;

  Duration get duration => Duration(seconds: 105);

  double get durationSeconds => duration.inSeconds.toDouble();

  double get currentTimePosition => Duration(seconds: 47).inSeconds.toDouble();

  double get playSpeed => 1.0;

  bool get isLooping => false;

  void seekTo(int time) {}

  Future<void> initController() async {}

  void dispose() {
    _offsetSubject.close();
    _controlsJsonSubject.close();
    _refreshSubject.close();
  }

  void initAsVideo() {}

  @override
  // TODO: implement controller
  get controller => throw UnimplementedError();

  @override
  // TODO: implement currentPositionStream
  Stream<double> get currentTimePositionStream =>
      BehaviorSubject.seeded(currentTimePosition);

  @override
  set looper(bool loop) {
    // TODO: implement looper
  }

  @override
  set speed(double speed) {
    // TODO: implement speed
  }

  @override
  // TODO: implement isPlayingStream
  Stream<bool> get isPlayingStream => BehaviorSubject.seeded(true);
}
