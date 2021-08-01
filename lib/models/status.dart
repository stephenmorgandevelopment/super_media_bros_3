
// TODO Experiment with this.
import 'dart:async';

import 'package:rxdart/rxdart.dart';

class Status<T>  {  //extends Stream<T> {
  T? data;
  Stage stage = Stage.initializing;

  Status();

// @override
  // StreamSubscription<T> listen(void Function(T event) onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
  //   // TODO: implement listen
  //   throw UnimplementedError();
  // }


}

enum Stage {initializing, working, complete}