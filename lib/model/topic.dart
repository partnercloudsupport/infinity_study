import 'package:infinity_study/model/question.dart';

class Topic {
  String name;
  String description;
  List<Question> questions;
  List<Topic> subTopics;

  Topic({this.name, this.description, this.subTopics, this.questions});

  factory Topic.fromJson(Map<String, dynamic> parsedJson) {
    return Topic(
      name: parsedJson['name'],
      description: parsedJson['description'],
      subTopics: core(parsedJson['subTopics']),
      questions: coreX(parsedJson['questions']),
    );
  }

  static List<Topic> core(dynamic subTopics) {
    var topics = new List<Topic>();

    if(subTopics != null) {
      for (var topic in subTopics) {
        var foodCard = new Topic.fromJson(topic);
        topics.add(foodCard);
      }
    }

    return topics;
  }

  static List<Question> coreX(dynamic subTopics) {
    var topics = new List<Question>();

    if(subTopics != null) {
      for (var topic in subTopics) {
        var foodCard = new Question.fromJson(topic);
        topics.add(foodCard);
      }
    }

    return topics;
  }
}