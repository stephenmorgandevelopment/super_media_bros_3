

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';
import 'package:super_media_bros_3/widgets/menus/menu_header.dart';

class ButtonGroupMenu extends StatelessWidget {
  final void Function(String tag) callback;
  ButtonGroupMenu(this.callback);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // key: endDrawerKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuHeaderBar("All Buttons:"),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding:
              EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              children: SuperMediaButtons(context, callback).controlButtons,
            ),
          ),
        ],
      ),
      elevation: 16.0,
    );
  }
}