import 'package:flutter/material.dart';
import 'package:infinity_study/flip_card.dart';

class MainTopicCard extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPressed;

  MainTopicCard({this.text, this.color = Colors.white, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      align: Alignment.center,
      color: color,
      text: text,
      textStyle: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
