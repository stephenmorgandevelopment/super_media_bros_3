import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/main.dart';
import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/widgets/controls/custom_sliders.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';

const String CLOSE_TAG = "close";
const String PLAY_TAG = "play-pause";
const String SPEED_TAG = "speed";
const String PREV_TAG = "prev";
const String SEEK_BACK_TAG = "seek-back";
const String SEEK_FWD_TAG = "seek-fwd";
const String NEXT_TAG = "next";
const String DETAILS_TAG = "details";
const String SHARE_TAG = "share";
const String ADD_TO_TAG = "add-to";
const String FAVORITE_TAG = "favorite";
const String BYTES_TAG = "bytes";
const String EDIT_TAG = "edit";
const String COPY_TAG = "copy";
const String MOVE_TAG = "move";
const String DELETE_TAG = "delete";
const String REPEAT_ONE_TAG = "repeat-one";
const String REPEAT_ALL_TAG = "repeat-all";
const String IMG_DETAIL_TAG = "details";

abstract class SuperMediaWidget implements Widget {
  String get tag;
  // String get json;

  Map toJson() {
    Map<String, dynamic> map = Map();
    map['tag'] = tag;
    return map;
  }

  static SuperMediaWidget fromTag(String tag) {
    switch(tag) {
      case TIME_SLIDER_TAG:
        return TimeSlider();
      case SPEED_SLIDER_TAG:
        return SpeedSelectSlider();
      default:
        return TimeSlider();
    }
  }

}

class SuperMediaButton extends IconButton with SuperMediaWidget {
  final String tag;

  SuperMediaButton({
    Function()? onPressed,
    required Icon icon,
    double iconSize = MediaOptions.iconsize,
    required this.tag,
  }) : super(onPressed: onPressed, icon: icon, iconSize: iconSize);

  bool isEqual(Object obj) {
    return obj is SuperMediaButton && this.tag == obj.tag;
  }

}

class SuperMediaButtons {
  final Function onPressed;
  final BuildContext context;

  // get callback => onPressed;

  SuperMediaButtons(this.context, this.onPressed);

  List<SuperMediaButton> get controlButtons => <SuperMediaButton>[
        speedBtn,
        prevBtn,
        seekBackBtn,
        seekFwdBtn,
        nextBtn,
        detailsBtn,
        shareBtn,
        addToBtn,
        favoriteBtn,
        bytesBtn,
        editBtn,
        copyBtn,
        moveBtn,
        deleteBtn,
        imgDetailsBtn,
        playBtn,
        repeatAllBtn,
        repeatOneBtn,
        videoPlayBtn,
      ];

  // String tagFor(IconButton btn) {
  //   switch (btn) {
  //     case playBtn:
  //   }
  // }

  SuperMediaWidget fromTag(String tag) {
    switch (tag) {
      case PLAY_TAG:
        return MediaControllerBlocProvider.of(context).bloc.type == Type.VIDEO
            ? videoPlayBtn
            : playBtn;
      case SPEED_TAG:
        return speedBtn;
      case PREV_TAG:
        return prevBtn;
      case SEEK_BACK_TAG:
        return seekBackBtn;
      case SEEK_FWD_TAG:
        return seekFwdBtn;
      case NEXT_TAG:
        return nextBtn;
      case DETAILS_TAG:
        return detailsBtn;
      case SHARE_TAG:
        return shareBtn;
      case ADD_TO_TAG:
        return addToBtn;
      case FAVORITE_TAG:
        return favoriteBtn;
      case BYTES_TAG:
        return bytesBtn;
      case EDIT_TAG:
        return editBtn;
      case COPY_TAG:
        return copyBtn;
      case MOVE_TAG:
        return moveBtn;
      case DELETE_TAG:
        return deleteBtn;
      case REPEAT_ONE_TAG:
        return repeatOneBtn;
      case REPEAT_ALL_TAG:
        return repeatAllBtn;
      case IMG_DETAIL_TAG:
        return imgDetailsBtn;
      default:
        return SuperMediaWidget.fromTag(tag);
    }
  }

  static SuperMediaButton closeBtnFrom(BuildContext context) =>
      SuperMediaButton(
        tag: CLOSE_TAG,
        onPressed: () => Navigator.pop(context),
        iconSize: 36.0,
        icon: Icon(
          Icons.close,
          color: Colors.white,
        ),
      );

  SuperMediaButton get closeBtn => SuperMediaButton(
        tag: CLOSE_TAG,
        onPressed: () => Navigator.pop(context),
        iconSize: 36.0,
        icon: Icon(
          Icons.close,
          color: Colors.white,
        ),
      );

  SuperMediaButton get repeatAllBtn => SuperMediaButton(
        tag: REPEAT_ALL_TAG,
        onPressed: () => onPressed(REPEAT_ALL_TAG),
        iconSize: MediaOptions.iconsize,
        icon: Icon(
          MediaControllerBlocProvider.of(context).isLooping
              ? Icons.repeat_on_outlined
              : Icons.repeat_outlined,
          color: Colors.white38,
        ),
      );

  SuperMediaButton get repeatOneBtn => SuperMediaButton(
        tag: REPEAT_ONE_TAG,
        onPressed: () => onPressed(REPEAT_ONE_TAG),
        iconSize: MediaOptions.iconsize,
        icon: Icon(
          MediaControllerBlocProvider.of(context).isLooping
              ? Icons.repeat_one_on_outlined
              : Icons.repeat_one_outlined,
          color: Colors.white38,
        ),
      );

  SuperMediaButton get playBtn => SuperMediaButton(
      tag: PLAY_TAG,
      onPressed: () => onPressed(PLAY_TAG),
      iconSize: MediaOptions.iconsize * MediaOptions.playBtnMultiplier,
      icon: Icon(
        MediaControllerBlocProvider.of(context).isPlaying
            ? Icons.pause_circle_filled_outlined
            : Icons.play_circle_fill_outlined,
        color: Colors.white38,
        semanticLabel: "Start or stop slideshow or audio playback.",
      ));

  SuperMediaButton get videoPlayBtn => SuperMediaButton(
      tag: PLAY_TAG,
      onPressed: () => onPressed(PLAY_TAG),
      iconSize: MediaOptions.iconsize * MediaOptions.videoPlayBtnMultiplier,
      icon: Icon(
        MediaControllerBlocProvider.of(context).isPlaying
            ? Icons.pause_circle_filled_outlined
            : Icons.play_circle_fill_outlined,
        color: Colors.white38,
        semanticLabel: "Play or pause the video.",
      ));

  SuperMediaButton get speedBtn => SuperMediaButton(
      tag: SPEED_TAG,
      onPressed: () => onPressed(SPEED_TAG),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.slow_motion_video_outlined,
        color: Colors.white38,
        semanticLabel: "Adjust playback speed of the video.",
      ));

  SuperMediaButton get prevBtn => SuperMediaButton(
      tag: PREV_TAG,
      onPressed: () => onPressed(PREV_TAG),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.skip_previous_outlined,
        color: Colors.white38,
        semanticLabel: "Previous video.",
      ));

  SuperMediaButton get seekBackBtn => SuperMediaButton(
      tag: SEEK_BACK_TAG,
      onPressed: () => onPressed(SEEK_BACK_TAG),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.fast_rewind_outlined,
        color: Colors.white38,
        semanticLabel: "Seek backwards in the video.",
      ));

  SuperMediaButton get seekFwdBtn => SuperMediaButton(
      tag: SEEK_FWD_TAG,
      onPressed: () => onPressed(SEEK_FWD_TAG),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.fast_forward_outlined,
        color: Colors.white38,
        semanticLabel: "Seek forward in the video.",
      ));

  SuperMediaButton get nextBtn => SuperMediaButton(
      tag: NEXT_TAG,
      onPressed: () => onPressed(NEXT_TAG),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.skip_next_outlined,
        color: Colors.white38,
        semanticLabel: "Next video.",
      ));

  SuperMediaButton get detailsBtn => SuperMediaButton(
      tag: DETAILS_TAG,
      onPressed: () => onPressed(DETAILS_TAG),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.info_outlined,
        color: Colors.white38,
        semanticLabel: "View details about the video.",
      ));

  SuperMediaButton get shareBtn => SuperMediaButton(
      tag: SHARE_TAG,
      onPressed: () => onPressed(SHARE_TAG),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.share_outlined,
        color: Colors.white38,
        semanticLabel: "Open the share manager.",
      ));

  SuperMediaButton get addToBtn => SuperMediaButton(
      tag: ADD_TO_TAG,
      onPressed: () => onPressed(ADD_TO_TAG),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.add_to_photos_outlined,
        color: Colors.white38,
        semanticLabel: "Add this to photos, a gallery, or an album.",
      ));

  SuperMediaButton get favoriteBtn => SuperMediaButton(
      tag: FAVORITE_TAG,
      onPressed: () => onPressed(FAVORITE_TAG),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.favorite_border,
        color: Colors.white38,
        semanticLabel: "Favorite this image.",
      ));

  SuperMediaButton get bytesBtn => SuperMediaButton(
      tag: BYTES_TAG,
      onPressed: () => onPressed(BYTES_TAG),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.code,
        color: Colors.white38,
        semanticLabel: "View this image's raw byte data.",
      ));

  SuperMediaButton get editBtn => SuperMediaButton(
      tag: EDIT_TAG,
      onPressed: () => onPressed(EDIT_TAG),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.tune,
        color: Colors.white38,
        semanticLabel: "Open this image in a photo editor.",
      ));

  SuperMediaButton get copyBtn => SuperMediaButton(
      tag: COPY_TAG,
      onPressed: () => onPressed(COPY_TAG),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.content_copy,
        color: Colors.white38,
        semanticLabel: "Copy this image to another album or folder.",
      ));

  SuperMediaButton get moveBtn => SuperMediaButton(
      tag: MOVE_TAG,
      onPressed: () => onPressed(MOVE_TAG),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.drive_file_move_outlined,
        color: Colors.white38,
        semanticLabel: "Move this image to another album or folder.",
      ));

  SuperMediaButton get deleteBtn => SuperMediaButton(
      tag: DELETE_TAG,
      onPressed: () => onPressed(DELETE_TAG),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.delete_outlined,
        color: Colors.white38,
        semanticLabel: "Delete this image.",
      ));

  SuperMediaButton get imgDetailsBtn => SuperMediaButton(
      tag: DETAILS_TAG,
      onPressed: () => onPressed(DETAILS_TAG),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.info_outlined,
        color: Colors.white38,
        semanticLabel: "View details from the image metadata.",
      ));
}
