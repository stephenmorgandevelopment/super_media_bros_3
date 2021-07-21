import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';

class ControlGroup extends StatelessWidget {
  final Key? key;
  final List<Widget> controlsWidgets;
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

}

class Position {
  double? top, bottom, left, right;

  Position(
      {this.top, this.right, this.bottom, this.left});

  Position.symmetric({horizontal = 0.0, vertical = 0.0})
      : this(
          top: vertical,
          bottom: vertical,
          left: horizontal,
          right: horizontal,
        );

  // static Position offsetFromPosition(Position position, {double? top, double? right, double? bottom, double? left}) {
  //   double? offTop = top == null ? position.top : position.top! + top;
  //   double? offBottom = bottom == null ? position.bottom :  position.bottom! + bottom;
  //   double? offRight = right == null ? position.right :  position.right! + right;
  //   double? offLeft = left == null ? position.left :  position.left! + left;
  //
  //   return Position(top: offTop, bottom: offBottom, right: offRight, left: offLeft);
  // }

  static Position centerAlign(BuildContext context, {bool isPlayBtn = false}) {
    Size size = MediaQuery.of(context).size;
    log("Size is: $size");

    double btnAdjustment = (MediaOptions.iconsize + 16.0) / 2;
    if(isPlayBtn) {
      btnAdjustment *= MediaControllerBlocProvider.of(context).bloc.type == Type.VIDEO
          ? MediaOptions.videoPlayBtnMultiplier
          : MediaOptions.playBtnMultiplier;
    }

    double top = (size.height/2) - btnAdjustment;
    double bottom = (size.height/2) - btnAdjustment;
    double right = (size.width/2) -btnAdjustment;
    double left = (size.width/2) -btnAdjustment;

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
    double? top = one.top == null ? (two.top == null?null:two.top) : one.top;
    double? bottom = one.bottom == null ? (two.bottom == null?null:two.bottom) : one.bottom;
    double? left = one.left == null ? (two.left == null?null:two.left) : one.left;
    double? right = one.right == null ? (two.right == null?null:two.right) : one.right;

    return Position(left: left, top: top, right: right, bottom: bottom);
  }
}
