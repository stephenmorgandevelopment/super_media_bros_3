

import 'package:flutter/material.dart';

class MediaGestureDetector extends GestureDetector {
  Widget? child;

  MediaGestureDetector({this.child});

  @override
  // TODO: implement onTap
  GestureTapCallback? get onTap => super.onTap;

  // @override
  // // TODO: implement onPanUpdate
  // GestureDragUpdateCallback? get onPanUpdate => ;


}

class Fling extends InkWell {

}