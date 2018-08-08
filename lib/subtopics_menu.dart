import 'package:flutter/material.dart';
import 'package:infinity_study/card_list_menu.dart';
import 'package:infinity_study/flip_card.dart';
import 'package:infinity_study/model/topic.dart';

class SubTopicsMenu extends StatelessWidget {
  final List<Topic> topics;
  final double height;
  final ScrollController _scrollController = new ScrollController();
  final Function callback;

  SubTopicsMenu({@required this.height, @required this.topics, this.callback});

  @override
  Widget build(BuildContext context) {
    return CardListMenu(
      height: height,
      scrollController: _scrollController,
      length: topics.length,
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
          child: new FlipCard(text: topics[index].name),
          onTap: () => callback(topics[index]),
        );
      },
    );
  }
}
