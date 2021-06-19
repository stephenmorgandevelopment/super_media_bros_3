import 'package:flutter/material.dart';

class TabbedTheme extends TabBarTheme {
  static Border tabBorder = Border.all(
    // color: Color.alphaBlend(Colors.lightBlueAccent, Colors.orangeAccent),
    color: Colors.orangeAccent,
    style: BorderStyle.solid,
    width: 0.25,
  );

  static LinearGradient tabGradient = LinearGradient(colors: <Color>[
    Color.fromARGB(205, 85, 85, 85),
    Color.fromARGB(255, 45, 45, 45)
  ], begin: Alignment.topLeft, end: Alignment.bottomRight);

  static BoxDecoration tabIndicator = BoxDecoration(
    border: tabBorder,
    gradient: tabGradient,
  );
}
