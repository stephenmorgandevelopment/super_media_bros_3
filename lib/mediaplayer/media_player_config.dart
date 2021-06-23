import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MediaPlayerConfig {
  static const String TAG = '_player_config';

  late Map<String, String> _config;

  Map<String, String> get config => _config;

  static MediaPlayerConfig? _instance;

  static MediaPlayerConfig get instance => _instance ?? MediaPlayerConfig._();

  factory MediaPlayerConfig() => instance;

  MediaPlayerConfig._() {
    _loadPrefs();
  }

  Future<void> addOrUpdate(String key, String value) async {
    if (!key.contains(TAG)) {
      _config[key] = value;
      key = "$key$TAG";
    } else {
      _config[key.replaceAll(TAG, "")] = value;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<void> _loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _config = new LinkedHashMap();
    for (String key in prefs.getKeys()
      ..removeWhere((key) {
        return !key.contains(TAG);
      })) {
      // if(key.contains(TAG))
      String k = key.replaceAll(TAG, "");
      config[key] = prefs.getString(key)!;
    }
  }
}

class ControlGroup {
  List<IconButton> buttons;
  Alignment alignment;
  bool horizontal = true;

  ControlGroup(this.buttons,
      {this.alignment = Alignment.bottomRight, this.horizontal = true});

  Widget compose() {
    Widget base;
    if (this.horizontal) {
      base = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: this.buttons,
      );
    } else {
      base = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: this.buttons,
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
      child: base,
      alignment: alignment,
    );
  }
}
