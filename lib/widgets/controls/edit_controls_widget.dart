import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/widgets/controls/control_group.dart';
import 'package:super_media_bros_3/widgets/controls/image_controls.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';
import 'package:super_media_bros_3/widgets/controls/media_controls.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';
import 'package:super_media_bros_3/widgets/controls/video_controls.dart';

const String ADD_CONTROL_GROUP_TAG = "add-control-group";
const String ADD_CONTROL_BUTTON_TAG = "add-contol-button";

class EditControls extends StatefulWidget {
  final Type type;

  EditControls(this.type);

  @override
  State createState() => _EditControlsState();
}

class _EditControlsState extends State<EditControls> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Key endDrawerKey = Key("smb-drawer");

  late String title;
  late Type controlsType;
  late MediaControls controls;
  late SuperMediaButtons smb;

  @override
  void initState() {
    smb = SuperMediaButtons(context, onPressed);

    switch (widget.type) {
      case Type.IMAGE:
        title = "Edit:Image";
        controls = ImageControls(onPressed);
        break;
      case Type.VIDEO:
        title = "Edit:Video";
        controls = VideoControls(onPressed);
        // TODO Understand why this doesn't work:
        // controls = VideoControls.from(smb);
        break;
      case Type.AUDIO:
        title = "Edit:Audio";
        controls = VideoControls(onPressed);
        // controls = AudioControls;
        break;
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: appbar,
        endDrawerEnableOpenDragGesture: true,
        endDrawer: Drawer(
          key: endDrawerKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                height: 60.0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(
                        "Media Buttons",
                        style: editDrawerHeaderStyle,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 0.0),
                      child: smb.closeBtn,
                      alignment: Alignment.centerRight,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  children: smb.controlButtons,
                ),
              ),
            ],
          ),
          elevation: 16.0,
        ),
        body: Stack(
          children: [
            // Container(
            //   constraints: BoxConstraints.expand(),
            //   child:
            // ),
            Container(
              // child: controls,
              constraints: BoxConstraints.expand(),
              child: DragTarget<ControlGroup>(
                builder: (BuildContext context, accepted, rejected) {
                  return Image.asset(
                    'images/thumbs.png',
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.high,
                    isAntiAlias: true,
                  );
                },
              ),
            ),
            controls,
          ],
        ),
      ),
    );
  }

  TextStyle editDrawerHeaderStyle = TextStyle(
    fontSize: 24.0,
  );

  AppBar get appbar => AppBar(
        title: Text(title),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline_outlined),
            iconSize: 40.0,
            onPressed: () => addControlGroup(),
          ),
          IconButton(
            icon: Icon(Icons.menu),
            iconSize: 40.0,
            onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
          ),
        ],
      );

  void addControlGroup() {
    if (widget.type == Type.VIDEO) {
      // String json = jsonEncode(controls);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (innerContext) =>
            SafeArea(
                child: Scaffold(
                    body: Text(MediaControllerBlocProvider.of(context).json!))),)
        ,
      );
    }
  }

  void onPressed(String tag) {
    // TODO make this button a draggable and assign new location accordingly.
  }
}

// class EditControlsAppBar extends StatefulWidget {
//   @override
//   State createState() => _EditControlsAppBarState();
// }
//
// class _EditControlsAppBarState extends State<EditControlsAppBar> {
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//
//     );
//   }
// }
