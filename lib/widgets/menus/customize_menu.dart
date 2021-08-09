import 'package:flutter/material.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/themes/text_styles.dart';
import 'package:super_media_bros_3/widgets/controls/edit_controls_widget.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';

class CustomizeMenu extends StatelessWidget {
  final BuildContext callingContext;

  CustomizeMenu(this.callingContext);

  void editControls(Type type) async {
    Navigator.push(
      this.callingContext,
      MaterialPageRoute(
          builder: (innerContext) => MediaControllerBlocProvider.forEditScreen(
              type,
              child: EditControls(type))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      children: [
        DrawerHeader(
          margin: EdgeInsets.all(0.0),
          child: Stack(
            children: [
              Container(
                  height: 38.0,
                  alignment: Alignment.topRight,
                  child: SuperMediaButtons.closeBtnFrom(context)),
              Container(
                margin: EdgeInsets.only(top: 25.0),
                height: 32.0,
                alignment: Alignment.topCenter,
                child: Text(
                  "Personalize your",
                  style: SuperTextStyles.drawerHeaderStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 21.0),
                  // This was a by-product of dozing off at the computer, lol.
                  // center: "He is trying tro get to the center"
                  alignment: Alignment.center,
                  child: Text(
                    "Super Media",
                    style: SuperTextStyles.drawerSuperMediaStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                // height: 30.0,
                left: 0.0,
                right: 0.0,
                bottom: 16.0,
                child: Container(
                  child: Text(
                    "Experience:",
                    style: SuperTextStyles.drawerHeaderStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          padding: EdgeInsets.all(0.0),
        ),
        ListTile(
          leading: Icon(Icons.image),
          title: Text(
            "Edit Image Controls",
            style: SuperTextStyles.drawerTextStyle,
          ),
          onTap: () => editControls(Type.IMAGE),
        ),
        ListTile(
          leading: Icon(Icons.movie),
          onTap: () => editControls(Type.VIDEO),
          title: Text(
            "Edit Video Controls",
            style: SuperTextStyles.drawerTextStyle,
          ),
        ),
        ListTile(
          leading: Icon(Icons.library_music),
          onTap: () => editControls(Type.AUDIO),
          title: Text(
            "Edit Audio Controls",
            style: SuperTextStyles.drawerTextStyle,
          ),
        ),
      ],
    );
  }
}
