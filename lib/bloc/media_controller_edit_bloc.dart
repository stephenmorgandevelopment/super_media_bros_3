import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
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

  // List<String> _controlGroupsJson = List.empty(growable: true);
  List<String> get controlGroupsJson =>
      ControlGroup.makeJsonListFrom(_controlGroups);
  // set controlGroupsJson(List<String> groupsJson) {
  //   _controlGroupsJson.clear();
  //   _controlGroupsJson.addAll(groupsJson);
  // }

  // void updateControlGroupsJson(String replacement, String replace) {
  //   _controlGroupsJson.removeWhere((groupJson) => groupJson == replace);
  //   _controlGroupsJson.add(replacement);
  // }

  List<ControlGroup> _controlGroups = List.empty(growable: true);
  List<ControlGroup> get controlGroups => _controlGroups;
  set controlGroups(List<ControlGroup> groups) {
    _controlGroups.clear();
    _controlGroups.addAll(groups);
  }

  void replaceControlGroupWithUpdated(ControlGroup controlGroup) {
    if (_controlGroups.remove(currentGroupEditing)) {
      log("currentEditingGroup was removed: ${controlGroup.toString}");
      _controlGroups.add(controlGroup);
    } else {
      log("Dart failed us removinge: ${controlGroup.toString}\n Zero surprise..fixing manually.");
      manuallyReplaceControlGroupWithUpdated(controlGroup);
    }
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
  // set _place_currentGroupEditing(ControlGroup group) {
  //   currentGroupEditing = group;
  //
  // }

  // void setCurrentGroupEditing() {
  //   for(ControlGroup grp in _controlGroups) {
  //     if(grp.key == currentGroupEditingKey) {
  //       log("currentGroupEditing set to ${grp.key}");
  //       currentGroupEditing = grp;
  //       break;
  //     }
  //   }
  // }

  Offset _offset = Offset(0.0, 0.0);
  final PublishSubject<Offset> _offsetSubject = PublishSubject<Offset>();
  // void updateData(DragUpdateDetails details) => _offsetSubject.sink.add(details.delta);
  void updateData(DragUpdateDetails details) {
    // log("offsetSubject updated: ${details.toString()}");
    _offsetSubject.sink.add(details.delta);
  }

  // _offsetSubject
  Sink<Offset> get offsetSink => _offsetSubject.sink;
  Stream<Offset> get offsetStream => _offsetSubject.stream;

  Offset _runningOffset = Offset(0.0, 0.0);
  Offset get runningOffset => _runningOffset;
  set runningOffset(Offset latest) {
    _runningOffset =
        Offset(_runningOffset.dx + latest.dx, _runningOffset.dy + latest.dy);
    // log("runningOffset: ${_runningOffset.toString()}");
  }

  Offset _mRunningOffset(Offset latest) =>
      Offset(_runningOffset.dx + latest.dx, _runningOffset.dy + latest.dy);

  Position? _runningPosition;
  Position get runningPosition =>
      _runningPosition ?? currentGroupEditing!.position;
  Stream<Position> get updatedGroupPosition => offsetStream.map((offset) {
        // log("Offset  inside updatedGroupPosition: $offset");
        // log("updatedGroupPosition called with: offset ${offset.toString()}");
        _runningPosition = runningPosition.updateFromOffset(offset);
        return _runningPosition!;
      });

  // final _isPlayingSink = BehaviorSubject<bool>();
  // Stream<bool> get isPlayingStream => _isPlayingSink.stream;
  // void _isPlayingListener() => _isPlayingSink.sink.add(isPlaying);

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
    // _currentlyEditingSubject.close();
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
