import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/models/media_resource.dart';
import 'package:super_media_bros_3/widgets/details_widget.dart';
import 'package:super_media_bros_3/widgets/controls/image_controls.dart';
import 'package:super_media_bros_3/widgets/media_view.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';

class ImageView extends MediaView {
  final MediaBloc _bloc;

  ImageView(this._bloc);

  @override
  State createState() => _ImageViewState();
}

class _ImageViewState extends MediaViewState<ImageView> {
  late Image _image;
  bool optionsShowing = false;
  bool isLeftFling = false;

  @override
  void initState() {
    _image = getImage(widget._bloc.currentMedia!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (optionsShowing) {
      return SafeArea(
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                child: Center(child: _image),
                onTap: _toggleOptions,
              ),
              ImageControls(onPressed),
            ],
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          body: GestureDetector(
            child: Center(child: _image),
            onTap: _toggleOptions,
            onPanEnd: (details) => processPan(details),
            onPanUpdate: (details) => {isLeftFling = (details.delta.dx < 0)},
          ),
        ),
      );
    }
  }

  TextStyle detailsTextStyle = TextStyle(
    color: Colors.white,
    backgroundColor: Colors.black38,
    fontSize: 18.0,
  );

  void onPressed(String btnTag) async {
    switch (btnTag) {
      case PLAY_TAG:
        // TODO play slideshow.
        break;
      case NEXT_TAG:
        changeMediaTo(await widget._bloc.getNextMedia()!);
        break;
      case PREV_TAG:
        changeMediaTo(await widget._bloc.getPreviousMedia()!);
        break;
      case DETAILS_TAG:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DetailsWidget(widget._bloc.currentMedia!.data)));
        break;
    }
  }

  void _toggleOptions() {
    optionsShowing = !optionsShowing;
    setState(() {});
  }

  void processPan(dynamic details) async {
    late MediaResource media;

    if (isLeftFling) {
      media = await widget._bloc.getNextMedia()!;
    } else {
      media = await widget._bloc.getPreviousMedia()!;
    }
    changeMediaTo(media);
  }

  void changeMediaTo(MediaResource media) async {
    _image = getImage(media);
    setState(() {});
  }

  Image getImage(MediaResource media) {
    Image image = media.bytes != null
        ? Image.memory(
            media.bytes!,
            fit: BoxFit.contain,
            alignment: Alignment.center,
            isAntiAlias: true,
          )
        : Image.file(
            media.file!,
            fit: BoxFit.contain,
            alignment: Alignment.center,
            isAntiAlias: true,
          );

    return image;
  }
}
