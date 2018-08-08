import 'package:flutter/material.dart';

class FlipCard extends StatelessWidget {
  final String text;
  final Color color;
  final Alignment align;
  final TextStyle textStyle;
  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;

  const FlipCard({
    @required this.text,
    this.color = Colors.white,
    this.margin = const EdgeInsets.all(4.0),
    this.padding = const EdgeInsets.all(12.0),
    this.align = Alignment.topLeft,
    this.textStyle = const TextStyle(
      fontSize: 14.0,
    ),
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return new Card(
      margin: margin,
      child: Container(
        color: color,
        alignment: align,
        child: Stack(
          alignment: align,
          children: [
            Padding(
              padding: padding,
              child: new Text(
                text,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
            ),
            child != null ? child : Container(),
          ],
        ),
      ),
    );
  }
}
