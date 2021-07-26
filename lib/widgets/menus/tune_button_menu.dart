

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_media_bros_3/widgets/menus/menu_header.dart';

class TuneButtonMenu extends StatelessWidget {
   final String tag;

  TuneButtonMenu(this.tag);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
          children: [
            MenuHeaderBar("Tune $tag:"),
            ListView()
          ],
        )
    );
  }
}

class TuneButtonView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _TuneButtonViewState();
}

class _TuneButtonViewState extends State<TuneButtonView> {
  // TODO this...

  @override
  Widget build(BuildContext context) {
    return Text("PLACEHOLDER :)");
  }
  // TODO ps.  Make sliders / text inputs / color pickers to configure things like
//  TODO button colors, time the seek buttons will skip.  The information displayed
//  TODO in the details screen. The size of the buttons.  And anything else anyone
//  TODO might ever possible want to custom configure about a media players controls.
}