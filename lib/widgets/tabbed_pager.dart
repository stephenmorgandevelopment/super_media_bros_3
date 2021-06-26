import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/themes/tab_themes.dart';
import 'package:super_media_bros_3/widgets/grid_view.dart';

class MediaTabPager extends StatefulWidget {
  final List<List<MediaData>> allMediaData;

  MediaTabPager(this.allMediaData);

  @override
  State createState() => _MediaTabPagerState();
}

const String HOME_TAG = 'Home';
const String PICTURES_TAG = 'Pictures';
const String VIDEOS_TAG = 'Videos';
const String AUDIO_TAG = 'Music';

class _MediaTabPagerState extends State<MediaTabPager>
    with SingleTickerProviderStateMixin {
  static const List<Tab> homeTabs = <Tab>[
    // Tab(
    //   text: SUPER_MEDIA_TAG,
    //   icon: Icon(Icons.home),
    // ),
    // Tab(text: PICTURES_TAG, icon: Icon(Icons.image)),
    // Tab(text: VIDEOS_TAG, icon: Icon(Icons.movie)),
    // Tab(text: AUDIO_TAG, icon: Icon(Icons.library_music)),
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
    // AppBar bar = context.findAncestorWidgetOfExactType<AppBar>() ?? AppBar();

    // return Scaffold(
    //   body: Column(
    //     verticalDirection: VerticalDirection.down,
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       TabBar(
    //         controller: _tabController,
    //         tabs: homeTabs,
    //         isScrollable: false,
    //         indicator: TabbedTheme.tabIndicator,
    //       ),
    //       // SliverAppBar(
    //       //   floating: true,
    //       //   pinned: true,
    //       //   bottom: TabBar(
    //       //     controller: _tabController,
    //       //     tabs: homeTabs,
    //       //     isScrollable: false,
    //       //     indicator: TabbedTheme.tabIndicator,
    //       //   ),
    //       // ),
    //       TabBarView(
    //         controller: _tabController,
    //         children: homeTabs.map((Tab tab) {
    //           final String label = tab.text!.toLowerCase();
    //           return MediaGridLayout(getBloc(tab.text!));
    //         }).toList(),
    //       )
    //     ],
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
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
    );
  }

  // List<Widget> tabViews = homeTabs.map((Tab tab) {
  //   final String label = tab.text!.toLowerCase();
  //   return MediaGridLayout(getBloc(tab.text!));
  // }).toList();

  static const Key HOME_KEY = Key(HOME_TAG);
  static const Key IMAGE_KEY = Key(PICTURES_TAG);
  static const Key VIDEO_KEY = Key(VIDEOS_TAG);
  static const Key AUDIO_KEY = Key(AUDIO_TAG);

  MediaBloc getBloc(Tab tab) {
    if (tab.key == IMAGE_KEY) {
      return MediaBloc(widget.allMediaData[0], Type.IMAGE);
    } else if (tab.key == VIDEO_KEY) {
      return MediaBloc(widget.allMediaData[1], Type.VIDEO);
    } else if (tab.key == AUDIO_KEY) {
      return MediaBloc(widget.allMediaData[2], Type.AUDIO);
    } else {
      List<MediaData> allData = List.from(widget.allMediaData[0]);
      allData.addAll(widget.allMediaData[1]);
      allData.addAll(widget.allMediaData[2]);

      return MediaBloc(allData, null);
    }

    // switch (tab.key) {
    //   case IMAGE_KEY:
    // return MediaBloc(
    //     widget.allMediaData
    //         .reduce((first, second) => first..addAll(second)),
    //     null);
    // List<MediaData> allData = List.from(widget.allMediaData[0]);
    // allData.addAll(widget.allMediaData[1]);
    // allData.addAll(widget.allMediaData[2]);

    // return MediaBloc(allData, null);
    // case PICTURES_TAG:
    //   return MediaBloc(widget.allMediaData[0], Type.IMAGE);
    // case VIDEOS_TAG:
    //   return MediaBloc(widget.allMediaData[1], Type.VIDEO);
    // case AUDIO_TAG:
    //   return MediaBloc(widget.allMediaData[2], Type.AUDIO);
    //
    // default:
    //   return MediaBloc(
    //       List.empty(),
    //       // widget.allMediaData
    //       //     .reduce((first, second) => first..addAll(second)),
    //       null);
    // }
  }
}
