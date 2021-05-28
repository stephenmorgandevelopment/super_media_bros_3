import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GridLayout extends StatefulWidget {
  int columnCount;

  GridLayout({this.columnCount = 3});

  @override
  State createState() => _GridLayoutState();
}

class _GridLayoutState extends State<GridLayout> {

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: widget.columnCount),
        itemBuilder: (BuildContext context, int index)) {

        }
      ;
  }

  Builder

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     width: double.infinity,
  //     height: double.infinity,
  //     padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0,),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.baseline,
  //       children: <Widget>[],
  //     ),
  //   );
  // }

  List<Row> buildRows() {
    List<Row> rows = [];


    return rows;
  }


}
