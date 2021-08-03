import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_controller_edit_bloc.dart';
import 'package:super_media_bros_3/mediaplayer/media_controls_config.dart';
import 'package:super_media_bros_3/mediaplayer/media_options.dart';
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

  bool _showModifyFab = false;
  bool _showMenuFab = true;

  late String title;
  late MediaControls controls;
  late SuperMediaButtons smb;

  MediaControllerEditBloc? _editBloc;
  MediaControllerEditBloc get editBloc =>
      _editBloc ?? (_editBloc = MediaControllerBlocProvider.ofEdit(context));

  @override
  void initState() {
    initControls();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    editBloc.controlsKey = _mediaControlsKey;

    editBloc.refreshStream.listen((_) => setState(() {}));

    editBloc.droppedUpdatedControlGroup.listen((updatedGroup) {
      editBloc.replaceControlGroupWithUpdated(updatedGroup);
      persistJson();
      initControls(refresh: true);
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
          // appBar: appbar,  // I liked the idea of an appbar, but it
          //  would make matching positions with the media objects difficult.
          //  Still bouncing it around.
          endDrawerEnableOpenDragGesture: true,
          endDrawer: menu,
          floatingActionButton: fab,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
          body: Container(
            constraints: BoxConstraints.expand(),
            child: DragTarget<ControlGroup>(
              onAccept: processControlGroupDrop,
              onWillAccept: verifyControlGroupCorrect,
              builder: (BuildContext context, accepted, rejected) {
                // TODO Make sure removing this stream builder doesn't break the views.
                // TODO refreshViews() should be updating all views now.
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
                        ),
                        controls,
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void btnMenuCallback(String tag) {

  }

  void onPressed(String tag) {

    if (editBloc.currentButtonEditingTag == tag) {  // If we have this buttun selected already.
      _showModifyFab = !_showModifyFab;
    } else if (!_showModifyFab) {   // If we don't have anything selected yet.
      _showModifyFab = true;
      editBloc.currentButtonEditingTag = tag;
    } else {    // If we have something selected, but not this button.
      editBloc.currentButtonEditingTag = tag;
    }

    setState(() {});
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
        // controls = AudioControls(    // Non-existent for now :)
        controls = VideoControls(
          onPressed,
          key: _mediaControlsKey,
          isEdit: true,
        );
        break;
    }

    // Previously dead code..been way too tired lately.
    // Probly to be removed.
    // if(refresh) {
    //   setState(() {});
    // }
  }

  processControlGroupDrop(ControlGroup oldGroup) async {
    log("Processing drop");
    // Not needed.  Was previously using this until
    // validation phase began receiving null objects.
  }

  bool verifyControlGroupCorrect(Object? oldGroup) {
    if(oldGroup == null) {
      // This happened a lot in building this out.  I need to figure out why,
      // but also accept the input for now.  Without a tangible object, there is
      // no way to actually validate this :(
      log("EditControls - oldGroup --NULL--.");
      return true;
    }

    if(oldGroup is ControlGroup && oldGroup.key == editBloc.currentGroupEditingKey) {
      log("EditControls - ${oldGroup.tag} validated successfully.");
      return true;
    }

    return false;
  }

  static const String btnMenuTag = "btnGroup";
  static const String tuneBtnTag = "tuneBtnMenu";

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

    if (editBloc.controlGroupsJson.isNotEmpty) {
      persistJson();
      log("Config successfully persisted.");
    } else {
      log("No config persisted.");
    }

    return true;
  }

  void persistJson() {
    MediaControlsConfig.updateJson(editBloc.type, editBloc.controlGroupsJson);
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
        child: Icon(Icons.menu, size: MediaOptions.fabSize, color: Colors.white,),
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

  // Not used yet, but will most likely need.  May be moved to bloc.
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
}
