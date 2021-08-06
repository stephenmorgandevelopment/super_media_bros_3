import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_media_bros_3/bloc/custom_sliders_bloc.dart';
import 'package:super_media_bros_3/bloc/media_controller_bloc.dart';
import 'package:super_media_bros_3/widgets/controls/media_controller_bloc_provider.dart';
import 'package:super_media_bros_3/widgets/controls/super_media_buttons.dart';

const TIME_SLIDER_TAG = "time-slider";
const SPEED_SLIDER_TAG = "speed-slider";

class TimeSlider extends StatefulWidget with SuperMediaWidget {
  // late final CustomSliderBloc _bloc;
  late final MediaControllerBloc _bloc;

  // TimeSlider(MediaControllerBloc bloc) : _bloc = CustomSliderBloc(bloc);
  TimeSlider(this._bloc);

  get tag => TIME_SLIDER_TAG;

  @override
  State createState() => _TimeSliderState();
}

class _TimeSliderState extends State<TimeSlider> with TickerProviderStateMixin {
  int currentTime = 0;
  // late MediaControllerBloc _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // _bloc = MediaControllerBlocProvider.of(context);
    super.didChangeDependencies();
  }

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
          builder: (BuildContext context, AsyncSnapshot<double> snapshot,) {
            if (snapshot.hasData) {
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
        Container(
          width: MediaQuery.of(context).size.width - 200.0,
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
    widget._bloc.seekTo(position.round());
    setState(() {});
  }

  String formatTime(double time) {
    NumberFormat minutesFormat = NumberFormat("##00");
    NumberFormat secondsFormat = NumberFormat("00");

    int minutes = (time / 60).floor();
    int seconds = (time - (minutes * 60)).round();

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
  get tag => SPEED_SLIDER_TAG;

  @override
  State createState() => _SpeedSelectSliderState();
}

class _SpeedSelectSliderState extends State<SpeedSelectSlider> {
  late final MediaControllerBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = MediaControllerBlocProvider.of(context);
    super.didChangeDependencies();
  }

  NumberFormat format = NumberFormat("0.00");
  late double sliderPosition = 1.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("0.25"),
        Expanded(
          child: Slider(
            min: 0.25,
            divisions: null,
            max: 3.0,
            value: _bloc.playSpeed,
            label: format.format(sliderPosition),
            onChanged: (position) => onSeekChanged(position),
            onChangeEnd: (position) => _bloc.speed = position,
          ),
        ),
        Text("3.0"),
      ],
    );
  }

  void onSeekChanged(double position) {
    sliderPosition = position;
  }
}
