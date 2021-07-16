import 'package:flutter/material.dart';

class ControlGroup extends StatelessWidget {
  final List<Widget> controlsWidgets;
  final Alignment alignment;
  final bool horizontal;
  final EdgeInsets margins;

  ControlGroup(
    this.controlsWidgets, {
    this.alignment = Alignment.bottomRight,
    this.horizontal = true,
    this.margins = const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
  });

  @override
  Widget build(BuildContext context) {
    Widget base = horizontal
        ? Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: this.controlsWidgets,
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: this.controlsWidgets,
          );

    return Container(
      margin: margins,
      child: base,
      alignment: alignment,
    );
  }
}
