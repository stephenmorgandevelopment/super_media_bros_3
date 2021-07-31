import 'package:flutter/cupertino.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/bloc/media_controller_edit_bloc.dart';
import 'package:super_media_bros_3/models/media_data.dart';

class MediaControllerBlocProvider extends InheritedWidget {
  final MediaControllerBloc controllerBloc;

  MediaBloc get mediaBloc => controllerBloc.bloc;

  MediaControllerBlocProvider(MediaBloc _bloc,
      {Key? key, Widget child = const Text("Unknown error.")})
      : controllerBloc = MediaControllerBloc(_bloc),
        super(key: key, child: child);

  MediaControllerBlocProvider.forEditScreen(Type type,
      {Key? key, Widget child = const Text("Unknown error.")})
      : controllerBloc = MediaControllerEditBloc(MediaBloc.empty(type)),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(MediaControllerBlocProvider old) {
    // if (controllerBloc.currentPosition != old.controllerBloc.currentPosition) {
    //   return true;
    // }
    if (mediaBloc.currentIndex != old.mediaBloc.currentIndex) {
      return true;
    }

    return true;
  }

  static MediaControllerEditBloc ofEdit(BuildContext context) {
    return (context
            .dependOnInheritedWidgetOfExactType<MediaControllerBlocProvider>()!)
        .controllerBloc as MediaControllerEditBloc;
  }

  static MediaControllerBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<MediaControllerBlocProvider>()!).controllerBloc;
  }
}
