import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_controller_edit_bloc.dart';
import 'package:super_media_bros_3/mediaplayer/media_controls_config.dart';
import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/widgets/controls/control_group.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';

class MenuHeaderBar extends StatelessWidget {
  late final BuildContext context;
  final String title;

  MenuHeaderBar(this.title);

  @override
  Widget build(BuildContext innerContext) {
    context = innerContext;

    return Container(
      color: Colors.orange,
      padding:
      EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      height: 56.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            child: IconButton(
              icon: Icon(Icons.save_outlined),
              iconSize: 36.0,
              onPressed: () => saveLayout(),
            ),
          ),
          Container(
          child: IconButton(
            // icon: Icon(Icons.restore_page_outlined),
            icon: Icon(Icons.restart_alt_outlined),
            iconSize: 36.0,
            onPressed: () => resetDefault(),
          ),
          ),
          Spacer(
            flex: 1,
          ),
          // Expanded(
          //   flex: 1,
          //   child: Text(
          //     title,
          //     style: editDrawerHeaderStyle,
          //     textAlign: TextAlign.left,
          //   ),
          // ),
          Container(
            child: IconButton(
              color: MediaOptions.superMediaButtonColor,
              icon: Icon(Icons.add_circle_outline_outlined),
              iconSize: 36.0,
              onPressed: () => showGeneratedJson(),
            ),
          ),
          Container(
            child: IconButton(
              icon: Icon(Icons.add_to_photos_outlined),
              iconSize: 36.0,
              color: MediaOptions.superMediaButtonColor,
              onPressed: () => showPersistedJson(),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 0.0),
            child: SuperMediaButtons.closeBtnFrom(context),
            alignment: Alignment.centerRight,
          ),
        ],
      ),
    );
  }

  MediaControllerEditBloc get _bloc => MediaControllerBlocProvider.ofEdit(context);
  Type get _type => _bloc.type;
  List<String> get _controlGroupsJson => _bloc.controlGroupsJson;

  Future<void> resetDefault() async {
    MediaControlsConfig.clearJson(_type);
    log("clearing json for _type");

    List<ControlGroup> genericGroups = _bloc.controlsKey?.currentState?.makeGeneric();
    MediaControlsConfig.updateJson(_type, ControlGroup.makeJsonListFrom(genericGroups));
    _bloc.refreshViews();
  }

  Future<void> saveLayout() async {
    return MediaControlsConfig.updateJson(_type, _controlGroupsJson);
    _bloc.refreshViews();
  }

  void showGeneratedJson() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (innerContext) => SafeArea(
          child: Scaffold(
            body: Text(MediaControllerBlocProvider.ofEdit(context).controlGroupsJson.join("\n")),
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

  final TextStyle editDrawerHeaderStyle = TextStyle(
    fontSize: 20.0,
    color: Colors.white,
  );
}