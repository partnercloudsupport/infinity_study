import 'package:infinity_study/model/card_model.dart';

class Question extends CardModel {
  String question;
  String answer;

  Question({this.question, this.answer});

  factory Question.fromJson(Map<String, dynamic> parsedJson) {
    return Question(
      question: parsedJson['question'],
      answer: parsedJson['answer'],
    );
  }
}