import 'dart:async';

import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final Stopwatch stopwatch;
  final Duration duration;
  final TextStyle textStyle;

  CountdownTimer({this.stopwatch, @required this.duration, this.textStyle = const TextStyle(fontSize: 30.0, color: Color(0x99000000))});

  @override
  _CountdownTimerState createState() => _CountdownTimerState(stopwatch: stopwatch);
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer timer;
  final Stopwatch stopwatch;

  _CountdownTimerState({this.stopwatch}) {
    timer = new Timer.periodic(new Duration(milliseconds: 30), callback);
  }

  void callback(Timer timer) {
    if (stopwatch.isRunning) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle timerTextStyle = widget.textStyle;
    String formattedTime = format(widget.duration.inMilliseconds - stopwatch.elapsedMilliseconds);
    return new Text(formattedTime, style: timerTextStyle);
  }

  static String format(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }
}
