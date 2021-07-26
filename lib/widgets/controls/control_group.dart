import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/models/position.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';

class ControlGroup extends StatelessWidget {
  final Key? key;
  final List<SuperMediaWidget> controlsWidgets;
  final bool horizontal;
  final Position position;

  ControlGroup(this.controlsWidgets, this.position, {this.horizontal = true, this.key});

  @override
  Widget build(BuildContext context) {

    Widget base = horizontal
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: this.controlsWidgets,
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: this.controlsWidgets,
          );

    return Positioned(
      key: this.key,
      child: base,
      left: position.left,
      top: position.top,
      right: position.right,
      bottom: position.bottom,
    );
  }

  static ControlGroup fromMap(Map<String, dynamic> map, SuperMediaButtons smb, {Key? key}) {
    return ControlGroup(
      makeWidgets(map['controlsWidgets'], smb),
      Position.fromJson(map['positions']),
      horizontal: map['horizontal'],
      key: key,
    );
  }

  static ControlGroup fromJson(String json, SuperMediaButtons smb, {Key? key}) {
    Map<String, dynamic> map = jsonDecode(json);

    return ControlGroup(
      makeWidgets(map['controlsWidgets'], smb),
      Position.fromJson(map['position']),
      horizontal: map['horizontal'],
      key: key,
    );
  }

  static List<SuperMediaWidget> makeWidgets(List<dynamic> maps, SuperMediaButtons smb) {
    List<SuperMediaWidget> widgets = List.empty(growable: true);

    for(Map map in maps) {
      widgets.add(smb.fromTag(map['tag']));
    }

    return widgets;
  }

  Map toJson() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['controlsWidgets'] = controlsWidgets;
    map['position'] = position; //.toJson();
    map['horizontal'] = horizontal;

    return map;
  }


}


