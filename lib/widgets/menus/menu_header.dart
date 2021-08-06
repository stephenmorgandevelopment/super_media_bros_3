import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/menu_header_bloc.dart';
import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';

// TODO Make this more modular.
class MenuHeaderBar extends StatelessWidget {
  late final BuildContext context;
  late final MenuHeaderBloc _bloc;

  final String? title;

  MenuHeaderBar(this.title);

  @override
  Widget build(BuildContext innerContext) {
    context = innerContext;

    var bloc = MediaControllerBlocProvider.ofEdit(context);
    _bloc = MenuHeaderBloc(bloc, isEdit: true);

    return Container(
      color: Colors.orange,
      padding:
      EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      height: 56.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: actionButtonsOrTitle..addAll([
          // Container(
          //   child: IconButton(
          IconButton(
              color: MediaOptions.superMediaButtonColor,
              icon: Icon(Icons.add_circle_outline_outlined),
              iconSize: 36.0,
              onPressed: () => _bloc.addMediaButton(),
            ),
          // ),
          // Container(
          //   child: IconButton(
          IconButton(
              icon: Icon(Icons.add_to_photos_outlined),
              iconSize: 36.0,
              color: MediaOptions.superMediaButtonColor,
              onPressed: () => _bloc.addControlGroup(),
            ),
          // ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 0.0),
            child: SuperMediaButtons.closeBtnFrom(context),
            alignment: Alignment.centerRight,
          ),
        ]),
      ),
    );
  }

  List<Widget> get actionButtonsOrTitle => title == null ?
      actionButtons : textTitle;

  List<Widget> get actionButtons => [
    Container(
      child: IconButton(
        icon: Icon(Icons.save_outlined),
        iconSize: 36.0,
        onPressed: () => _bloc.saveLayout(),
      ),
    ),
    Container(
      child: IconButton(
        // icon: Icon(Icons.restore_page_outlined),
        icon: Icon(Icons.restart_alt_outlined),
        iconSize: 36.0,
        onPressed: () => _bloc.resetDefault(),
      ),
    ),
    Spacer(
      flex: 1,
    ),
  ];

  List<Widget> get textTitle => [
    Expanded(
      flex: 1,
      child: Text(
        title!,
        style: editDrawerHeaderStyle,
        textAlign: TextAlign.left,
      ),
    ),
  ];

  final TextStyle editDrawerHeaderStyle = TextStyle(
    fontSize: 20.0,
    color: Colors.white,
  );
}