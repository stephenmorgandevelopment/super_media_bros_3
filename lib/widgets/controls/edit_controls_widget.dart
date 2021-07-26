import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_controller_edit_bloc.dart';
import 'package:super_media_bros_3/mediaplayer/media_controls_config.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/widgets/controls/control_group.dart';
import 'package:super_media_bros_3/widgets/controls/image_controls.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';
import 'package:super_media_bros_3/widgets/controls/media_controls.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';
import 'package:super_media_bros_3/widgets/controls/video_controls.dart';
import 'package:super_media_bros_3/widgets/menus/button_group_menu.dart';
import 'package:super_media_bros_3/widgets/menus/tune_button_menu.dart';

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
  final GlobalKey<MediaControlsState> _mediaControlsKey =
      GlobalKey<MediaControlsState>();

  // final Key endDrawerKey = Key("smb-drawer");
  bool _showModifyFab = false;
  bool _showMenuFab = false;

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
        controls = ImageControls(
          onPressed,
          key: _mediaControlsKey,
          isEdit: true,
        );
        break;
      case Type.VIDEO:
        title = "Edit:Video";
        controls = VideoControls(
          onPressed,
          key: _mediaControlsKey,
          isEdit: true,
        );
        break;
      case Type.AUDIO:
        title = "Edit:Audio";
        controls = VideoControls(
          onPressed,
          key: _mediaControlsKey,
          isEdit: true,
        );
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
    return WillPopScope(
      onWillPop: saveOnExit,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          // appBar: appbar,
          endDrawerEnableOpenDragGesture: true,
          endDrawer: menu,
          floatingActionButton: fab,
          body: Stack(
            children: [
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
      ),
    );
  }

  static const String btnMenuTag = "btnGroup";
  static const String tuneBtnTag = "tuneBtnMenu";

  // String currentMenu = btnMenuTag;
  String get currentMenu => _showModifyFab ? tuneBtnTag : btnMenuTag;

  get menu {
    switch (currentMenu) {
      case btnMenuTag:
        return btnGroupMenu;
      case tuneBtnTag:
        return tuneBtnMenu;
    }
  }

  get btnGroupMenu => ButtonGroupMenu(btnMenuCallback);

  get tuneBtnMenu => TuneButtonMenu(editBloc.currentButtonEditingTag);

  Future<bool> saveOnExit() async {
    if (MediaControllerBlocProvider.ofEdit(context)
        .controlGroupsJson
        .isNotEmpty) {
      persistJson();
      log("Config successfully persisted.");
      return true;
    } else {
      log("No config persisted.");
      return true;
    }
  }

  void persistJson() {
    var bloc = MediaControllerBlocProvider.ofEdit(context);
    MediaControlsConfig.writeConfigToPersistence(
        bloc.bloc.type!, bloc.controlGroupsJson);
  }

  bool dragging = false;

  get fab {
    if (!dragging) {
      if (_showModifyFab) {
        return tuneButtonFab;
      }
      if (_showMenuFab) {
        return openMenuFab;
      }
    }

    return null;
    // return Positioned(height: 0.0, width: 0.0, top: 0.0,
    //     child: Material(
    //       type: MaterialType.transparency,
    //     ));
  }

  get openMenuFab =>
      // height: 64.0,
      FloatingActionButton(
        mini: false,
        child: Icon(Icons.menu, size: 48.0, color: Colors.white),

        backgroundColor: Color.fromARGB(215, 195, 195, 195),
        splashColor: Colors.orangeAccent,
        onPressed: () =>
            _scaffoldKey.currentState!.openEndDrawer(), // addControlGroup(),
      );

  get tuneButtonFab => FloatingActionButton(
        mini: false,
        child: Icon(Icons.tune_outlined, size: 48.0, color: Colors.white),
        backgroundColor: Color.fromARGB(215, 195, 195, 195),
        splashColor: Colors.orangeAccent,
        onPressed: () =>
            _scaffoldKey.currentState!.openEndDrawer(), // addControlGroup(),
      );

  // AppBar get appbar => AppBar(
  //
  //       title: Text(title),
  //       automaticallyImplyLeading: true,
  //       actions: [
  //         IconButton(
  //           icon: Icon(Icons.add_circle_outline_outlined),
  //           iconSize: 40.0,
  //           onPressed: () => addControlGroup(),
  //         ),
  //         IconButton(
  //           icon: Icon(Icons.menu),
  //           iconSize: 40.0,
  //           onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
  //         ),
  //       ],
  //     );

  void onPressed(String tag) {
    if (_showModifyFab && editBloc.currentButtonEditingTag == tag) {
      _showModifyFab = false;
      editBloc.currentButtonEditingTag = 'null';
    } else if (!_showModifyFab) {
      _showModifyFab = true;
      editBloc.currentButtonEditingTag = tag;
    } else {
      editBloc.currentButtonEditingTag = tag;
    }

    editBloc.currentGroupEditing = getMatchingControlGroups();

    setState(() {});
  }

  MediaControllerEditBloc? _editBloc;

  MediaControllerEditBloc get editBloc =>
      _editBloc ?? (_editBloc = MediaControllerBlocProvider.ofEdit(context));

  Key? getMatchingControlGroups() {
    if (editBloc.currentButtonEditingTag == 'null') {
      return null;
    }
    for (ControlGroup group in editBloc.controlGroups) {
      if (group.controlsWidgets
          .contains(smb.fromTag(editBloc.currentButtonEditingTag))) {
        return group.key;
      }
    }
  }

  void btnMenuCallback(String tag) {}

  void showGeneratedJson() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (innerContext) => SafeArea(
          child: Scaffold(
            body: Text(MediaControllerBlocProvider.ofEdit(context)
                .controlGroupsJson
                .join("\n")),
          ),
        ),
      ),
    );
  }

  void showPersistedJson() async {
    var bloc = MediaControllerBlocProvider.of(context).bloc;
    var json = (await MediaControlsConfig.readConfigFromPersistence(bloc.type!))
        .join("\n");

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (innerContext) => SafeArea(
                    child: Scaffold(
                  body: Text(json),
                ))));
  }
}
