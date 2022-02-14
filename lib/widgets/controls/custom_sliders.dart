import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
import 'package:super_media_bros_3/mediaplayer/media_options.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';

const TIME_SLIDER_TAG = "time-slider";
const SPEED_SLIDER_TAG = "speed-slider";

class TimeSlider extends StatefulWidget with SuperMediaWidget {
  final MediaControllerBloc _bloc;

  TimeSlider(this._bloc);

  get tag => TIME_SLIDER_TAG;

  @override
  State createState() => _TimeSliderState();
}

class _TimeSliderState extends State<TimeSlider> with TickerProviderStateMixin {
  double currentPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      height: 50.0,
      width: MediaQuery.of(context).size.width - 20.0,
      alignment: Alignment.bottomCenter,
      child: Material(
        child: StreamBuilder(
          stream: widget._bloc.currentTimePositionStream,
          initialData: currentPosition,
          builder: (
            BuildContext context,
            AsyncSnapshot<double> snapshot,
          ) =>
              buildSlider(snapshot.data!),
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
        Container(
          width: MediaQuery.of(context).size.width - 205.0,
          child: Slider(
            min: 0.00,
            divisions: null,
            max: widget._bloc.durationSeconds,
            value: data,
            label: formatTime(currentPosition),
            onChanged: (position) => onSeekChanged(position),
            onChangeEnd: (position) => onUserChanged(position),
          ),
        ),
        Text(formatDuration()),
      ],
    );
  }

  void onUserChanged(double position) {
    widget._bloc.seekTo(position.round());
    setState(() {});
  }

  NumberFormat minutesFormat = NumberFormat("##00");
  NumberFormat secondsFormat = NumberFormat("00");

  String formatTime(double time) {
    int minutes = (time / 60).floor();
    int seconds = (time - (minutes * 60)).ceil();

    return "${minutesFormat.format(minutes)}:${secondsFormat.format(seconds)}";
  }

  String formatDuration() {
    return formatTime(widget._bloc.durationSeconds);
  }

  void onSeekChanged(double position) {
    currentPosition = position;
    setState(() {});
  }
}

class SpeedSelectSlider extends StatefulWidget with SuperMediaWidget {
  final MediaControllerBloc _bloc;

  SpeedSelectSlider(this._bloc);

  get tag => SPEED_SLIDER_TAG;

  @override
  State createState() => _SpeedSelectSliderState();
}

class _SpeedSelectSliderState extends State<SpeedSelectSlider> {
  NumberFormat decimalHundredth = NumberFormat("0.00");
  late double sliderPosition = 1.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20.0,
      color: MediaOptions.speedSelectorBackground,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("0.25"),
          Expanded(
            child: Slider(
              activeColor: Color.fromARGB(255, 237, 153, 22),
              min: 0.25,
              divisions: null,
              max: 3.0,
              value: widget._bloc.playSpeed,
              label: decimalHundredth.format(sliderPosition),
              onChanged: (position) => onSeekChanged(position),
              onChangeEnd: (position) => widget._bloc.speed = position,
            ),
          ),
          Text("3.0"),
        ],
      ),
    );
  }

  void onSeekChanged(double position) {
    sliderPosition = position;
    setState(() {});
  }
}
