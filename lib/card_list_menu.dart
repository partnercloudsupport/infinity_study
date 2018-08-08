import 'package:flutter/material.dart';

class CardListMenu extends StatelessWidget {
  final Function itemBuilder;
  final ScrollController scrollController;
  final double height;
  final int length;

  CardListMenu({this.itemBuilder, this.height, this.length, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(
          maxHeight: height,
        ),
        child: new ListView.builder(
            controller: scrollController,
            itemCount: length,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(12.0),
            itemBuilder: itemBuilder));
  }
}
