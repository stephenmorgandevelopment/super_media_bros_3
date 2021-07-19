import 'package:flutter/material.dart';
import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/widgets/controls/control_group.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';

const String PLAY_TAG = "play-pause";
const String SPEED_TAG = "speed";
const String PREV_TAG = "prev";
const String SEEK_BACK_TAG = "seek-back";
const String SEEK_FWD_TAG = "seek-fwd";
const String NEXT_TAG = "next";
const String DETAILS_TAG = "details";
const String SHARE_TAG = "share";
const String ADD_TO_TAG = "addto";
const String FAVORITE_TAG = "favorite";
const String BYTES_TAG = "bytes";
const String EDIT_TAG = "edit";
const String COPY_TAG = "copy";
const String MOVE_TAG = "move";
const String DELETE_TAG = "delete";
const String LOOPING_TAG = "looping";
const String IMG_DETAIL_TAG = "details";

class SuperMediaButtons {
  Function onPressed;
  BuildContext context;

  SuperMediaButtons(this.context, this.onPressed);

  List<IconButton> get controlButtons => <IconButton>[
    videoPlayBtn, speedBtn, prevBtn, seekBackBtn, seekFwdBtn, nextBtn, detailsBtn,
    shareBtn, addToBtn, favoriteBtn, bytesBtn, editBtn, copyBtn, moveBtn,
    deleteBtn, imgDetailsBtn, playBtn
  ];

  IconButton get playBtn => IconButton(
      onPressed: () => onPressed(PLAY_TAG),
      iconSize: MediaOptions.iconsize * MediaOptions.playBtnMultiplier,
      icon: Icon(
        MediaControllerBlocProvider.of(context).isPlaying
            ? Icons.pause_circle_filled_outlined
            : Icons.play_circle_fill_outlined,
        color: Colors.white38,
        semanticLabel: "Start or stop slideshow or audio playback.",
      ));

  IconButton get videoPlayBtn => IconButton(
      onPressed: () => onPressed(PLAY_TAG),
      iconSize: MediaOptions.iconsize * MediaOptions.videoPlayBtnMultiplier,
      icon: Icon(
        MediaControllerBlocProvider.of(context).isPlaying
            ? Icons.pause_circle_filled_outlined
            : Icons.play_circle_fill_outlined,
        color: Colors.white38,
        semanticLabel: "Play or pause the video.",
      ));

  IconButton get speedBtn => IconButton(
      onPressed: () => onPressed(SPEED_TAG),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.slow_motion_video_outlined,
        color: Colors.white38,
        semanticLabel: "Adjust playback speed of the video.",
      ));

  IconButton get prevBtn => IconButton(
      onPressed: () => onPressed("prev"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.skip_previous_outlined,
        color: Colors.white38,
        semanticLabel: "Previous video.",
      ));

  IconButton get seekBackBtn => IconButton(
      onPressed: () => onPressed("seek-back"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.fast_rewind_outlined,
        color: Colors.white38,
        semanticLabel: "Seek backwards in the video.",
      ));

  IconButton get seekFwdBtn => IconButton(
      onPressed: () => onPressed("seek-fwd"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.fast_forward_outlined,
        color: Colors.white38,
        semanticLabel: "Seek forward in the video.",
      ));

  IconButton get nextBtn => IconButton(
      onPressed: () => onPressed("next"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.skip_next_outlined,
        color: Colors.white38,
        semanticLabel: "Next video.",
      ));

  IconButton get detailsBtn => IconButton(
      onPressed: () => onPressed("details"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.info_outlined,
        color: Colors.white38,
        semanticLabel: "View details about the video.",
      ));

  IconButton get shareBtn => IconButton(
      onPressed: () => onPressed("share"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.share_outlined,
        color: Colors.white38,
        semanticLabel: "Open the share manager.",
      ));

  IconButton get addToBtn => IconButton(
      onPressed: () => onPressed("addto"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.add_to_photos_outlined,
        color: Colors.white38,
        semanticLabel: "Add this to photos, a gallery, or an album.",
      ));

  IconButton get favoriteBtn => IconButton(
      onPressed: () => onPressed("favorite"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.favorite_border,
        color: Colors.white38,
        semanticLabel: "Favorite this image.",
      ));

  IconButton get bytesBtn => IconButton(
      onPressed: () => onPressed("bytes"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.code,
        color: Colors.white38,
        semanticLabel: "View this image's raw byte data.",
      ));

  IconButton get editBtn => IconButton(
      onPressed: () => onPressed("edit"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.tune,
        color: Colors.white38,
        semanticLabel: "Open this image in a photo editor.",
      ));

  IconButton get copyBtn => IconButton(
      onPressed: () => onPressed("copy"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.content_copy,
        color: Colors.white38,
        semanticLabel: "Copy this image to another album or folder.",
      ));

  IconButton get moveBtn => IconButton(
      onPressed: () => onPressed("move"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.drive_file_move_outlined,
        color: Colors.white38,
        semanticLabel: "Move this image to another album or folder.",
      ));

  IconButton get deleteBtn => IconButton(
      onPressed: () => onPressed("delete"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.delete_outlined,
        color: Colors.white38,
        semanticLabel: "Delete this image.",
      ));

  IconButton get imgDetailsBtn => IconButton(
      onPressed: () => onPressed("details"),
      iconSize: MediaOptions.iconsize,
      icon: Icon(
        Icons.info_outlined,
        color: Colors.white38,
        semanticLabel: "View details from the image metadata.",
      ));

}