import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/themes/tab_themes.dart';
import 'package:super_media_bros_3/widgets/controls/edit_controls_widget.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';
import 'package:super_media_bros_3/widgets/grid_view.dart';
import 'package:video_player/video_player.dart';

class MediaTabPager extends StatefulWidget {
  final List<MediaBloc> mainMediaBlocs;

  MediaTabPager(this.mainMediaBlocs);

  @override
  State createState() => _MediaTabPagerState();
}

const String HOME_TAG = 'Home';
const String PICTURES_TAG = 'Pictures';
const String VIDEOS_TAG = 'Videos';
const String AUDIO_TAG = 'Music';

const Key HOME_KEY = Key(HOME_TAG);
const Key IMAGE_KEY = Key(PICTURES_TAG);
const Key VIDEO_KEY = Key(VIDEOS_TAG);
const Key AUDIO_KEY = Key(AUDIO_TAG);

class _MediaTabPagerState extends State<MediaTabPager>
    with SingleTickerProviderStateMixin {

  static const List<Tab> homeTabs = <Tab>[
    Tab(
      icon: Icon(Icons.home),
      key: HOME_KEY,
    ),
    Tab(icon: Icon(Icons.image), key: IMAGE_KEY),
    Tab(icon: Icon(Icons.movie), key: VIDEO_KEY),
    Tab(icon: Icon(Icons.library_music), key: AUDIO_KEY),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: homeTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: menuBtn,
          title: Text('Super Media Bros'),
          bottom: TabBar(
            controller: _tabController,
            tabs: homeTabs,
            isScrollable: false,
            indicator: TabbedTheme.tabIndicator,
          )),
      body: TabBarView(
        controller: _tabController,
        children: homeTabs.map((Tab tab) {
          return MediaGridLayout(getBloc(tab));
        }).toList(),
      ),
      // drawer: , // Settings menu eventually.
    );
  }

  MediaBloc getBloc(Tab tab) {
    if (tab.key == IMAGE_KEY) {
      return widget.mainMediaBlocs[0];
    } else if (tab.key == VIDEO_KEY) {
      return widget.mainMediaBlocs[1];
    } else if (tab.key == AUDIO_KEY) {
      return widget.mainMediaBlocs[2];
    } else {
      return MediaBloc.empty(null);
    }
  }

  Widget get menuBtn =>
      IconButton(
        onPressed: () => editControls(Type.VIDEO),
        icon: Icon(
          Icons.menu_outlined,
          color: Colors.white,
        ),
      );

  void editControls(Type type) async {
    var controller = VideoPlayerController.asset('images/test.mp4');
    MediaData data = VideoData(Uri.parse(controller.dataSource), Source.LOCAL);
    MediaBloc bloc = MediaBloc(<MediaData>[data], Type.VIDEO);
    bloc.loadCurrentMedia();

    controller.dispose();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              MediaControllerBlocProvider(bloc,
                  child: EditControls(type))),
    );
  }
}
