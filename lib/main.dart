import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_media_bros_3/data/image_access.dart';
import 'package:super_media_bros_3/data/media_interface.dart';
import 'package:super_media_bros_3/models/media.dart';
import 'package:super_media_bros_3/widgets/grid_layout.dart';

import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
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
  Future<List<Media>> mediaFuture = ImageAccess.getAllImagesData();
  late List<Media> testList;

  _MyHomePageState() {
    // checkPermissions();
    // if (MediaAccess.hasReadPermission) {
    //   this.mediaFuture = ImageAccess.getAllImagesData();
    // }
  }

  @override
  Widget build(BuildContext context) {
    checkPermissions();
    // if(testList != null && testList.isEmpty) {
    //   setState(() {
    //
    //   });
    // }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: mediaFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Media>> snapshot) {
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
            // return MediaGridLayout();
            // } else if (snapshot.hasData) {
          } else  {
            return MediaGridLayout(media: testList);
            // return MediaGridLayout(media: snapshot.data ?? <Media>[]);
          // } else {
          //   return MediaGridLayout(media: testList ?? <Media>[]);
          }
        },
      ),
      // body: MediaGridLayout(),
    );
  }

  Future<void> checkPermissions() async {
    testList = await ImageAccess.getAllImagesData();

    if (!MediaAccess.hasReadPermission) {
      await MediaAccess.requestPermission();

      setState(() {
        // if (MediaAccess.hasReadPermission) {
        //   this.mediaFuture = ImageAccess.getAllImagesData();
        // }
      });
    // } else {
    //   this.testList = await ImageAccess.getAllImagesData();
    //
    //   setState(() {
    //
    //   });
    }
  }
}
