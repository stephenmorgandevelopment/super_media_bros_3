import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/widgets/controls/control_group.dart';
import 'package:super_media_bros_3/widgets/controls/image_controls.dart';
import 'package:super_media_bros_3/widgets/controls/media_controls.dart';
import 'package:super_media_bros_3/widgets/controls/video_controls.dart';

class EditControls extends StatefulWidget {
  final Type type;

  EditControls(this.type);

  @override
  State createState() => _EditControlsState();
}

class _EditControlsState extends State<EditControls> {
  late String title;
  late Type controlsType;
  late MediaControls controls;

  @override
  void initState() {
    switch (widget.type) {
      case Type.IMAGE:
        title = "Edit:Image";
        controls = ImageControls(callback);
        break;
      case Type.VIDEO:
        title = "Edit:Video";
        controls = VideoControls(callback);
        break;
      case Type.AUDIO:
        title = "Edit:Audio";
        controls = VideoControls(callback);
        // controls = AudioControls;
        break;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: Stack(
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
          Container(
            child: controls,
            // child: DragTarget<ControlGroup>(
            //   builder: (BuildContext context, accepted, rejected) {
            //     return controls;
            //   },
            // ),
          )
        ],
      ),
    );
  }

  AppBar get appbar => AppBar(
        title: Text(title),
      );

  void callback(String tag) {
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
