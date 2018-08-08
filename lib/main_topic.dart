import 'package:flutter/material.dart';
import 'package:infinity_study/main_topic_card.dart';
import 'package:infinity_study/model/topic.dart';

class MainTopic extends StatelessWidget {
  final Topic currentTopic;
  final Function navigateBack;
  final Function flipCard;
  final Widget child;

  MainTopic({this.currentTopic, this.navigateBack, this.flipCard, this.child});

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      child: GestureDetector(
        onTap: flipCard,
        child: Stack(
          children: <Widget>[
            currentTopic?.isBack ?? false
                ? MainTopicCard(
                    text: currentTopic.description,
                    color: new Color(0x22000000),
                    onPressed: navigateBack,
                  )
                : MainTopicCard(
                    text: currentTopic.name,
                    onPressed: navigateBack,
                  ),
            child ?? Container(),
          ],
        ),
      ),
    );
  }
}
