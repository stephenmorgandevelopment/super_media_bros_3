import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_controller_edit_bloc.dart';
import 'package:super_media_bros_3/mediaplayer/media_controls_config.dart';
import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/models/position.dart';
import 'package:super_media_bros_3/widgets/controls/control_group.dart';
import 'package:super_media_bros_3/widgets/controls/image_controls.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';
import 'package:super_media_bros_3/widgets/controls/media_controls.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';
import 'package:super_media_bros_3/widgets/controls/video_controls.dart';
import 'package:super_media_bros_3/widgets/menus/button_group_menu.dart';
import 'package:super_media_bros_3/widgets/menus/tune_button_menu.dart';

const String ADD_CONTROL_GROUP_TAG = "add-control-group";
const String ADD_CONTROL_BUTTON_TAG = "add-control-button";

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
  bool _showMenuFab = true;

  late String title;
  late Type controlsType;
  late MediaControls controls;
  late SuperMediaButtons smb;

  MediaControllerEditBloc? _editBloc;

  MediaControllerEditBloc get editBloc =>
      _editBloc ?? (_editBloc = MediaControllerBlocProvider.ofEdit(context));

  // Future<ControlGroup?> get latestDroppedUpdatedControlGroup async => editBloc.droppedUpdatedControlGroup.last;

  @override
  void initState() {
    initControls();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    editBloc.controlsKey = _mediaControlsKey;

    editBloc.refreshStream.listen((_) => setState(() {

    }));

    editBloc.droppedUpdatedControlGroup.listen((updatedGroup) {
      editBloc.replaceControlGroupWithUpdated(updatedGroup);
      persistJson();
      initControls(refresh: true);
      // setState(() {});
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          // appBar: appbar,
          endDrawerEnableOpenDragGesture: true,
          endDrawer: menu,
          floatingActionButton: fab,
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          body: Container(
            constraints: BoxConstraints.expand(),
            child: DragTarget<ControlGroup>(
              onAccept: processControlGroupDrop,
              // onAcceptWithDetails: processControlGroupDrop,
              onWillAccept: verifyControlGroupCorrect,
              // onAccept: (_) => persistJson(),
              builder: (BuildContext context, accepted, rejected) {
                return StreamBuilder(
                  stream: editBloc.controlsJsonStringStream,
                  builder: (BuildContext innaInnContext, AsyncSnapshot<List<String>> snapshot) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          constraints: BoxConstraints.expand(),
                          child: Image.asset(
                            'images/thumbs.png',
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.high,
                            isAntiAlias: true,
                          ),
                          // controls,
                        ),
                        controls,
                      ],
                    );
                  },
                );

                // return Stack(
                //   fit: StackFit.expand,
                //   children: [
                //     Container(
                //       constraints: BoxConstraints.expand(),
                //       child: Image.asset(
                //         'images/thumbs.png',
                //         fit: BoxFit.fill,
                //         filterQuality: FilterQuality.high,
                //         isAntiAlias: true,
                //       ),
                //       // controls,
                //     ),
                //     controls,
                //   ],
                // );
              },
            ),
          ),
        ),
      ),
    );
  }

  void initControls({refresh = false}) {
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

        if(refresh) {
          setState(() {

          });
        }
    }
  }

  processControlGroupDrop(ControlGroup oldGroup) async {
    log("Processing drop");

    // Position updatedPosition = details.data;
    // ControlGroup oldGroup = editBloc.currentGroupEditing!;
    // ControlGroup updatedGroup = ControlGroup(
    //   editBloc,
    //   oldGroup.controlsWidgets,
    //   updatedPosition,
    //   horizontal: oldGroup.horizontal,
    //   key: oldGroup.key,
    // );
    // ControlGroup updatedGroup = (await latestDroppedUpdatedControlGroup)!;
    // editBloc.replaceControlGroupWithUpdated(updatedGroup);
    //
    // log("${oldGroup.toString()} was replaced by ${updatedGroup.toString()}");

    // persistJson();
    // setState(() {});
  }

  bool verifyControlGroupCorrect(dynamic oldGroup) {
    // processControlGroupDrop(oldGroup);
    // log("Will I accept the drop...willAccept called");
    //
    // if (oldGroup == null) {
    //   log("Object is null buddy...no drop for you.");
    //   log("Shhhh...don't tell anybody, but I can work around that in a hot second.");
    //   return false;
    // }
    // if (oldGroup is ControlGroup) {// && oldGroup.key == editBloc.currentGroupEditingKey) {
    //   log("${oldGroup} verified.");
    //   return true;
    // }
    // log("${oldGroup} is not verified. isGroup: ${oldGroup is ControlGroup} and ${oldGroup.key!} == ${editBloc.currentGroupEditingKey}");
    // return false;
    return true;
  }

  // void offsetListener(Offset offset) {
  //   curPos.top = pos.top == null ? null : pos.top + offset.dy;
  //   curPos.bottom = pos.bottom == null ? null : pos.bottom + offset.dy;
  //   curPos.left = pos.left == null ? null : pos.left + offset.dx;
  //   curPos.right = pos.right == null ? null : pos.right + offset.dx;
  // }

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

  Future<bool> onBackPressed() async {
    if (editBloc.currentButtonEditingTag != 'null') {
      setState(() {
        editBloc.currentButtonEditingTag = 'null';
        _showModifyFab = false;
      });
      return false;
    }

    if (MediaControllerBlocProvider.ofEdit(context)
        .controlGroupsJson
        .isNotEmpty) {
      persistJson();
      log("Config successfully persisted.");
      // return true;
    } else {
      log("No config persisted.");
      // return true;
    }

    return true;
  }

  void persistJson() {
    // MediaControllerEditBloc bloc = MediaControllerBlocProvider.ofEdit(context);
    MediaControlsConfig.updateJson(
        editBloc.bloc.type!, editBloc.controlGroupsJson);
    // MediaControlsConfig.writeConfigToPersistence(
    // bloc.bloc.type!, bloc.controlGroupsJson);
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
  }

  get openMenuFab =>
      // height: 64.0,
      FloatingActionButton(
        mini: false,
        child: Icon(Icons.menu, size: 48.0, color: Colors.white),
        backgroundColor: MediaOptions.fabBackgroundColor,
        splashColor: Colors.orangeAccent,
        onPressed: () =>
            _scaffoldKey.currentState!.openEndDrawer(), // addControlGroup(),
      );

  get tuneButtonFab => FloatingActionButton(
        mini: false,
        child: Icon(Icons.tune_outlined, size: 48.0, color: Colors.white),
        backgroundColor: MediaOptions.fabBackgroundColor,
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
    // editBloc.currentButtonEditing

    if (editBloc.currentButtonEditingTag == tag) {
      _showModifyFab = !_showModifyFab;
    } else if (!_showModifyFab) {
      _showModifyFab = true;
      editBloc.currentButtonEditingTag = tag;
    } else {
      editBloc.currentButtonEditingTag = tag;
    }



    setState(() {});
  }

  Key? getMatchingControlGroupKey() {
    if (editBloc.currentButtonEditingTag == 'null') {
      return null;
    }
    for (ControlGroup group in editBloc.controlGroups) {
      for (SuperMediaWidget widget in group.controlsWidgets) {
        if (widget.tag == editBloc.currentButtonEditingTag) {
          return group.key;
        }
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
