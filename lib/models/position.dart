import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';

class Position {
  double? top, bottom, left, right;

  Position({this.top, this.right, this.bottom, this.left});

  @override
  String toString() {
    return "Position(top: $top, right: $right, bottom: $bottom, left: $left)";
  }

  Position.symmetric({horizontal = 0.0, vertical = 0.0})
      : this(
          top: vertical,
          bottom: vertical,
          left: horizontal,
          right: horizontal,
        );

  Position updateFromOffset(Offset offset) {
    double? topAdj = top == null ? null : top! + offset.dy;
    double? bottomAdj = bottom == null ? null : bottom! + offset.dy;
    double? leftAdj = left == null ? null : left! + offset.dx;
    double? rightAdj = right == null ? null : right! + offset.dx;

    return Position(
        top: topAdj,
        bottom: bottomAdj,
        left: leftAdj,
        right: rightAdj,
    );
  }



  Position.fromJson(Map<String, dynamic> map)
      : top = map['top'],
        bottom = map['bottom'],
        left = map['left'],
        right = map['right'];

  static Position fromMap(Map<String, dynamic> map) {
    return Position(
      top: map['top'],
      bottom: map['bottom'],
      left: map['left'],
      right: map['right'],
    );
  }

  Map toJson() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['top'] = top;
    map['bottom'] = bottom;
    map['left'] = left;
    map['right'] = right;

    return map;
  }

  static Position centerAlign(BuildContext context, {bool isPlayBtn = false}) {
    Size size = MediaQuery.of(context).size;
    log("Size is: $size");

    double btnAdjustment = (MediaOptions.iconsize + 24.0) / 2;
    if (isPlayBtn) {
      btnAdjustment *=
          MediaControllerBlocProvider.of(context).bloc.type == Type.VIDEO
              ? MediaOptions.videoPlayBtnMultiplier
              : MediaOptions.playBtnMultiplier;
    }

    double top = (size.height / 2) - btnAdjustment;
    double bottom = (size.height / 2) - btnAdjustment;
    double right = (size.width / 2) - btnAdjustment;
    double left = (size.width / 2) - btnAdjustment;

    return Position(top: top, bottom: bottom, right: right, left: left);
  }

  static Position bottomAlign() {
    return Position(bottom: 12.0);
  }

  static Position topAlign() {
    return Position(top: 12.0);
  }

  static Position rightAlign() {
    return Position(right: 12.0);
  }

  static Position leftAlign() {
    return Position(left: 12.0);
  }

  static Position combine(Position one, Position two) {
    double? top =
        one.top == null ? (two.top == null ? null : two.top) : one.top;
    double? bottom = one.bottom == null
        ? (two.bottom == null ? null : two.bottom)
        : one.bottom;
    double? left =
        one.left == null ? (two.left == null ? null : two.left) : one.left;
    double? right =
        one.right == null ? (two.right == null ? null : two.right) : one.right;

    return Position(left: left, top: top, right: right, bottom: bottom);
  }
}
