import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/data/media_interface.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/widgets/needs_permission_text.dart';
import 'package:super_media_bros_3/widgets/tabbed_pager.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class AppGlobals {
  static double statusBarHeight = 0.0;

  static late MediaBloc _imageBloc;
  static late MediaBloc _videoBloc;
  static late MediaBloc _audioBloc;
}

class MyApp extends StatelessWidget {
  // TODO Figure out the best way to initialize and keep these in memory.
  static late MediaBloc _imageBloc;
  static late MediaBloc _videoBloc;
  static late MediaBloc _audioBloc;

  // TODO Get rid of these by finding a better way of init'ing previous TODO.
  static bool _isReady = false;
  static late Future<void> _initialized;

  MyApp();

  static Future<List<MediaBloc>> get mainBlocs async {
    if (_isReady) {
      return List.from(
        {_imageBloc, _videoBloc, _audioBloc},
        growable: true,
      );
    } else {
      log("mainBlocs called - not ready yet.");
      await _initialized;
      log("mainBlocs after await _initialized - ready: ${_isReady.toString()}");
      return mainBlocs;
    }
  }

  // TODO Change to async* and attempt conversion to StreamBuilder.
  static Future<void> initData() async {
    List<MediaData> imageList = await MediaAccess.getAllData(Type.IMAGE);
    List<MediaData> videoList = await MediaAccess.getAllData(Type.VIDEO);
    List<MediaData> audioList = await MediaAccess.getAllData(Type.AUDIO);

    _imageBloc = MediaBloc(imageList, Type.IMAGE);
    _videoBloc = MediaBloc(videoList, Type.VIDEO);
    _audioBloc = MediaBloc(audioList, Type.AUDIO);

    _isReady = true;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _initialized = initData();

    return MaterialApp(
      title: 'Super Media Bros',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Super Media Bros'),
      routes: {
        NeedsPermissionText.NEEDS_PERMISSION: (context) =>
            NeedsPermissionText(),
      },
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<MediaBloc>> mediaFuture = MyApp.mainBlocs;

  @override
  void initState() {
    super.initState();
  }

  _MyHomePageState() {
    checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    // TODO Attempt conversion to StreamBuilder.
    return FutureBuilder(
        future: mediaFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<MediaBloc>> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return SafeArea(
              child: MediaTabPager(snapshot.data!),
            );
          }

          if (!MediaAccess.hasReadPermission) {
            return explainPermission;
          }

          return Center(child: CircularProgressIndicator());
        });
  } // @override

  Future<void> checkPermissions() async {
    if (!MediaAccess.hasReadPermission) {
      await MediaAccess.requestPermission();
      mediaFuture = MyApp.mainBlocs;
      setState(() {});
    } else {
      mediaFuture = MyApp.mainBlocs;
    }

    // mediaFuture = MyApp.mainBlocs;
  }

  Widget get explainPermission => NeedsPermissionText();

  void explainPerms() {
    Navigator.pushNamed(context, NeedsPermissionText.NEEDS_PERMISSION);
  }
}
