
import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/models/media_resource.dart';
import 'package:super_media_bros_3/widgets/details_widget.dart';
import 'package:super_media_bros_3/widgets/controls/image_controls.dart';
import 'package:super_media_bros_3/widgets/media_view.dart';
import 'package:super_media_bros_3/widgets/super_media_buttons.dart';

class ImageView extends StatefulWidget with MediaView {
  final MediaBloc _bloc;

  ImageView(this._bloc);

  @override
  State createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
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

// class ImageOptionsTop extends StatelessWidget {
//   static final double iconsize = 56.0;
//
//   final MediaResource media;
//
//   ImageOptionsTop(this.media);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: makeOptions(),
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       mainAxisSize: MainAxisSize.min,
//     );
//   }
//
//   List<Widget> makeOptions() {
//     return <Widget>[
//       IconButton(
//           onPressed: () => onPressed("share"),
//           iconSize: iconsize,
//           icon: Icon(
//             Icons.share_outlined,
//             color: Colors.white38,
//             semanticLabel: "Open the share manager.",
//           )),
//       IconButton(
//           onPressed: () => onPressed("addto"),
//           iconSize: iconsize,
//           icon: Icon(
//             Icons.add_to_photos_outlined,
//             color: Colors.white38,
//             semanticLabel: "Add this to photos, a gallery, or an album.",
//           )),
//       IconButton(
//           onPressed: () => onPressed("favorite"),
//           iconSize: iconsize,
//           icon: Icon(
//             Icons.favorite_border,
//             color: Colors.white38,
//             semanticLabel: "Favorite this image.",
//           )),
//     ];
//   }
//
//   void onPressed(String button) {
//     switch (button) {
//       case "share":
//         break;
//       case "favorite":
//         break;
//       case "addto":
//         break;
//     }
//   }
// }
//
// class ImageOptionsBottom extends StatelessWidget {
//   static final double iconsize = 44.0;
//   late BuildContext ctx;
//
//   final MediaResource media;
//
//   ImageOptionsBottom(this.media);
//
//   @override
//   Widget build(BuildContext context) {
//     this.ctx = context;
//
//     return Row(
//       children: makeOptions(),
//       crossAxisAlignment: CrossAxisAlignment.end,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       mainAxisSize: MainAxisSize.min,
//     );
//   }
//
//   List<Widget> makeOptions() {
//     return <Widget>[
//       IconButton(
//           onPressed: () => onPressed("bytes"),
//           iconSize: iconsize,
//           icon: Icon(
//             Icons.code,
//             color: Colors.white38,
//             semanticLabel: "View this image's raw byte data.",
//           )),
//       IconButton(
//           onPressed: () => onPressed("edit"),
//           iconSize: iconsize,
//           icon: Icon(
//             Icons.tune,
//             color: Colors.white38,
//             semanticLabel: "Open this image in a photo editor.",
//           )),
//       IconButton(
//           onPressed: () => onPressed("copy"),
//           iconSize: iconsize,
//           icon: Icon(
//             Icons.content_copy,
//             color: Colors.white38,
//             semanticLabel: "Copy this image to another album or folder.",
//           )),
//       IconButton(
//           onPressed: () => onPressed("move"),
//           iconSize: iconsize,
//           icon: Icon(
//             Icons.drive_file_move_outlined,
//             color: Colors.white38,
//             semanticLabel: "Move this image to another album or folder.",
//           )),
//       IconButton(
//           onPressed: () => onPressed("delete"),
//           iconSize: iconsize,
//           icon: Icon(
//             Icons.delete_outlined,
//             color: Colors.white38,
//             semanticLabel: "Delete this image.",
//           )),
//       IconButton(
//           onPressed: () => onPressed("details"),
//           iconSize: iconsize,
//           icon: Icon(
//             Icons.info_outlined,
//             color: Colors.white38,
//             semanticLabel: "View details from the image metadata.",
//           )),
//     ];
//   }
//
//   void onPressed(String button) async {
//     switch (button) {
//       case "bytes":
//         Uint8List? bytes = media.bytes ?? await media.file?.readAsBytes();
//
//         if (bytes != null) {
//           ByteData bdata = bytes.buffer.asByteData(0, bytes.lengthInBytes);
//           StringBuffer stringBuffer = StringBuffer();
//           for (int i = 0; i < bdata.lengthInBytes; i + 512) {
//             if ((bdata.lengthInBytes - i) > 512) {
//               stringBuffer.write(bdata.buffer.asByteData(i, 512));
//             } else {
//               stringBuffer
//                   .write(bdata.buffer.asByteData(i, (bdata.lengthInBytes - i)));
//             }
//           }
//           Widget text = Text(
//             stringBuffer.toString(),
//             softWrap: true,
//           );
//
//           Navigator.push(ctx, MaterialPageRoute(builder: (context) => text));
//         }
//         break;
//       case "edit":
//         break;
//       case "copy":
//         break;
//       case "move":
//         break;
//       case "share":
//         break;
//       case "details":
//         break;
//     }
//   }
// }
