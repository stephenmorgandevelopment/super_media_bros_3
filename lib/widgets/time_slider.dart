import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';

class TimeSlider extends StatefulWidget {
  TimeSlider();

  @override
  State createState() => _TimeSliderState();
}

class _TimeSliderState extends State<TimeSlider> with TickerProviderStateMixin {
  // late AnimationController controller;
  int currentTime = 0;
  NumberFormat minutesFormat = NumberFormat("##00");
  NumberFormat secondsFormat = NumberFormat("00");

  late MediaControllerBloc _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloc = MediaControllerBlocProvider.of(context);
    super.didChangeDependencies();
  }

  double currentPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
      height: 50.0,
      alignment: Alignment.bottomCenter,
      child: Material(
        child: StreamBuilder(
          stream: _bloc.currentPositionStream,
          builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
            if(snapshot.hasData) {
              return buildSlider(snapshot.data!);
            } else {
              return placeHolderBox();
            }
          },
        ),
      ),
    );
  }

  Widget buildSlider(double data) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(formatTime(data)),
          Slider(
            min: 0.00,
            divisions: null,
            max: _bloc.durationSeconds,
            value: data,
            // label: _bloc
            //     .currentPosition
            //     .toString(),
            onChanged: (position) => onSeekChanged(position),
            onChangeEnd: (position) => onUserChanged(position),
          ),
          Text(formatDuration()),
        ],
      );
  }

  Widget placeHolderBox() {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.5, -0.6),
          radius: 0.15,
          colors: <Color>[
            Color(0xFFEEEEEE),
            Color(0xFF111133),
          ],
          stops: <double>[0.9, 1.0],
        ),
      ),
    );
  }

  void onUserChanged(double position) {
    _bloc.seekTo(position.round());
    setState(() {});
  }

  String formatTime(double time) {
    int minutes = (time / 60).round();
    int seconds = (time - (minutes * 60)).round();

    return "${minutesFormat.format(minutes)}:${secondsFormat.format(seconds)}";
  }

  String formatDuration() {
    return formatTime(MediaControllerBlocProvider.of(context).durationSeconds);
  }

  void onSeekChanged(double position) {
    currentPosition = position;

    setState(() {});
  }
}
