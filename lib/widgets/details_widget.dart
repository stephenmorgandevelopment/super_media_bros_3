import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_media_bros_3/models/media_data.dart';

class DetailsWidget extends StatelessWidget {
  final MediaData data;

  DetailsWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.metadata["_display_name"]!),
      ),
      body: Material(
        type: MaterialType.transparency,
        child: ListView(
          padding: EdgeInsets.all(12.0),
          children: getTextList(),
        ),
      ),
    );
  }

  List<Widget> getTextList() {
    List<Widget> dataTexts = List.empty(growable: true);

    // TODO Parse the non-human readable data to human readable.
    for (MapEntry entry in data.metadata.entries) {
      dataTexts.add(
        Material(
          child: Text(
            "${entry.key}: ${entry.value}",
            style: detailsTextStyle,
          ),
          type: MaterialType.transparency,
        ),
      );
    }

    return dataTexts;
  }

  final TextStyle detailsTextStyle = TextStyle(
    color: Colors.white,
    backgroundColor: Colors.transparent,
    fontSize: 24.0,
  );
}
