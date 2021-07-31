import 'package:flutter/cupertino.dart';
import 'package:super_media_bros_3/models/position.dart';

class DragPositionData extends Position {
  // Position position;
  Offset offset = Offset.zero;

  DragPositionData(Position position) : super(
    top: position.top,
    bottom: position.bottom,
    left: position.left,
    right: position.right,
  );

  void updateData(Offset delta) {
    offset = delta;
  }


}