import 'package:flutter/cupertino.dart';

class MediaOptions {
  // TODO Map these to shared preferences (flutter equivalent).
  // TODO Save when changed and load at runtime.

  // Misc Options
  static String audioGroupBy = "album";

  // Times
  static int seekForwardTime = 7500;
  static int seekBackwardsTime = 3500;

  // Sizes
  static const double iconsize = 48.0;
  static double videoPlayBtnMultiplier = 2.25;
  static double playBtnMultiplier = videoPlayBtnMultiplier / 1.5;
  static const fabSize = 48.0;

  // Colors
  static const Color selectedColor = Color.fromARGB(152, 82, 255, 31);
  static const Color controlGroupBackgroundColor = Color.fromARGB(165, 145, 145, 145);
  static const Color fabBackgroundColor = Color.fromARGB(215, 195, 195, 195);
  static const Color superMediaButtonColor = Color.fromARGB(205, 235, 235, 235);
  static const Color dragHighlightColor = Color.fromARGB(139, 255, 157, 0);
  static const Color speedSelectorBackground = Color.fromARGB(198, 56, 234, 169);
}
