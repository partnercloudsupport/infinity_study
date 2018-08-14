import 'package:flutter/material.dart';

class TabMenu extends StatelessWidget {
  const TabMenu({
    @required this.controller,
    @required this.subMenuDuration,
    @required this.curve,
    @required this.animatedHeight,
  });

  final TabController controller;
  final Duration subMenuDuration;
  final Curve curve;
  final double animatedHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2 -
              (controller.animation.value - 0.5) * 150,
          child: AnimatedContainer(
            duration: subMenuDuration,
            curve: curve,
            alignment: Alignment.center,
            color: Color.lerp(
                Color(0xFFFFFFCC), Color(0xFFFFFF33), animatedHeight),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: new Text(
                "Sub Topics",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2 +
              (controller.animation.value - 0.5) * 150,
          child: AnimatedContainer(
            duration: subMenuDuration,
            curve: curve,
            color: Color.lerp(
                Color(0xFFDDEEFF), Color(0xFF55AAFF), animatedHeight),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: new Text(
                "Questions",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
