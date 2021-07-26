import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/widgets/controls/control_group.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';

abstract class MediaControls extends StatefulWidget {
  @protected
  final Function(String tag) callback;
  final bool isEdit;

  MediaControls(this.callback, {Key? key, this.isEdit = false}) : super(key: key);
}

abstract class MediaControlsState<T extends MediaControls> extends State<T> {
  @protected
  late SuperMediaButtons smb;

  @override
  void didChangeDependencies() {
    smb = SuperMediaButtons(context, widget.callback);

    super.didChangeDependencies();
  }

  makeControls();

  Map toJson() {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map['controls'] = makeControls();

    return map;
  }
}
