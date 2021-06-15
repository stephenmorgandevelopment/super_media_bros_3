import 'package:flutter/material.dart';
import 'package:super_media_bros_3/bloc/media_bloc.dart';
import 'package:super_media_bros_3/data/media_interface.dart';
import 'package:super_media_bros_3/models/media_data.dart';
import 'package:super_media_bros_3/widgets/tabbed_pager.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  static late MediaBloc imageBloc;
  static late MediaBloc videoBloc;
  static late MediaBloc audioBloc;

  static Future<List<List<MediaData>>> buildData() async {
    List<MediaData> imageList = await MediaAccess.getAllData(Type.IMAGE);
    List<MediaData> videoList = await MediaAccess.getAllData(Type.VIDEO);
    List<MediaData> audioList = await MediaAccess.getAllData(Type.AUDIO);
    // imageList = await MediaAccess.getAllData(Type.IMAGE);
    // videoList = await MediaAccess.getAllData(Type.VIDEO);
    // audioList = await MediaAccess.getAllData(Type.AUDIO);

    // setState(() {});
    return List.from(<List<MediaData>>[imageList, videoList, audioList]);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Media Bros',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Super Media Bros'),
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
  // Future<List<MediaData>> mediaFuture = ImageAccess.getAllData();
  late Future<List<List<MediaData>>> mediaFuture;

  // late MediaBloc imageBloc;
  // late MediaBloc videoBloc;
  // late MediaBloc audioBloc;

  // late List<MediaData> imageList;
  // late List<MediaData> videoList;
  // late List<MediaData> audioList;

  @override
  void initState() {
    super.initState();

    mediaFuture = MyApp.buildData();
  }

  _MyHomePageState() {
    checkPermissions();
    // if (MediaAccess.hasReadPermission) {
    //   this.mediaFuture = ImageAccess.getAllImagesData();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // child: MediaTabPager(mediaFuture),
      child: FutureBuilder(
          future: mediaFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<List<MediaData>>> snapshot) {
            if (!MediaAccess.hasReadPermission) {
              return Center(
                child: Text(
                  'This is a media app dumbass...\nWTF you expect it to do without access to media?!??!??!',
                  style: TextStyle(
                    color: Colors.greenAccent[700],
                    fontSize: 24.0,
                  ),
                ),
              );
            } else {
              if (snapshot.hasData && snapshot.data != null) {
                return MediaTabPager(snapshot.data!);
              } // return MediaGridLayout(ImageScreenBloc(imageList));
            }

            return Text('Well....this is awkard.\nHow did we get here???');
          }),
    );
  } // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(widget.title),
  //     ),
  //     body: FutureBuilder(
  //       future: mediaFuture,
  //       builder: (BuildContext context,
  //           AsyncSnapshot<List<List<MediaData>>> snapshot) {
  //         if (!MediaAccess.hasReadPermission) {
  //           return Center(
  //             child: Text(
  //               'This is a media app dumbass...\nWTF you expect it to do without access to media?!??!??!',
  //               style: TextStyle(
  //                 color: Colors.greenAccent[700],
  //                 fontSize: 24.0,
  //               ),
  //             ),
  //           );
  //         } else {
  //           return Tabbed
  //           // return MediaGridLayout(ImageScreenBloc(imageList));
  //         }
  //       },
  //     ),
  //     // body: MediaGridLayout(),
  //   );
  // }

  Future<void> checkPermissions() async {
    // testList = await ImageAccess.getAllData();
    // testList = await VideoAccess.getAllData();
    // testList = await AudioAccess.getAllData();

    if (!MediaAccess.hasReadPermission) {
      await MediaAccess.requestPermission();
      // buildImageData();

      setState(() {});
    }
  }
}
