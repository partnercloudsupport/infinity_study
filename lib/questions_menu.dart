import 'package:flutter/material.dart';
import 'package:infinity_study/card_list_menu.dart';
import 'package:infinity_study/flip_card.dart';
import 'package:infinity_study/model/card_model.dart';
import 'package:infinity_study/model/question.dart';

class QuestionsMenu extends StatelessWidget {
  final List<Question> questions;
  final VoidCallback callback;
  final double height;
  final ScrollController _scrollController = new ScrollController();

  QuestionsMenu(
      {@required this.height, @required this.questions, this.callback});

  void toggleQuestion(CardModel card) {
    card.isBack = !card.isBack;
    questions.where((q) => q != card).forEach((q) => q.isBack = false);
  }

  @override
  Widget build(BuildContext context) {
    return CardListMenu(
      height: height,
      scrollController: _scrollController,
      length: questions.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            toggleQuestion(questions[index]);
            if (questions[index].isBack) {
              var scrollTo = 15 + index * 48.0;
              if (scrollTo >= _scrollController.position.maxScrollExtent) {
                //scrollTo = _scrollController.position.maxScrollExtent;
                //TODO: cannot scroll if list is smaller.
              }
              _scrollController.animateTo(scrollTo,
                  duration: new Duration(milliseconds: 300),
                  curve: Curves.ease);
            }
            callback();
          },
          child: Column(
            children: [
              new FlipCard(
                text: questions[index].question,
                margin: questions[index].isBack
                    ? EdgeInsets.only(
                        right: 4.0, left: 4.0, top: 4.0, bottom: 0.0)
                    : EdgeInsets.all(4.0),
              ),
              questions[index].isBack
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: new FlipCard(
                        text: questions[index].answer,
                        color: Color(0x22000000),
                        margin:
                            EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
                      ),
                    )
                  : new Container(),
            ],
          ),
        );
      },
    );
  }
}
