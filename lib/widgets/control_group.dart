

import 'package:flutter/material.dart';

class ControlGroup {
  List<IconButton> buttons;
  Alignment alignment;
  bool horizontal = true;

  ControlGroup(this.buttons,
      {this.alignment = Alignment.bottomRight, this.horizontal = true});

  Widget compose() {
    Widget base = horizontal ?
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: this.buttons,
        ) :
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: this.buttons,
        );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
      child: base,
      alignment: alignment,
    );
  }
}