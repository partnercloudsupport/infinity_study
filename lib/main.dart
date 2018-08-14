import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_study/core/quickDismissible.dart';
import 'package:infinity_study/main_topic.dart';
import 'package:infinity_study/model/question.dart';
import 'package:infinity_study/model/topic.dart';
import 'package:infinity_study/sub_menu.dart';

void main() {
  runApp(new MaterialApp(
    showPerformanceOverlay: false,
    debugShowCheckedModeBanner: false,
    title: 'Flutter UI Test',
    theme: new ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: new CoreApp(title: 'Flutter UI Test'),
  ));
}

class CoreApp extends StatefulWidget {
  CoreApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CoreAppState createState() => new _CoreAppState();
}

class _CoreAppState extends State<CoreApp> {
  Topic root;
  bool dataLoaded = false;

  Queue previousTopics;
  Topic currentTopic;
  List<Topic> subTopics;
  List<Question> questions;
  double maxAvailableHeight = 500.0;
  int _counter = 0;


  Widget topicCard;
  Widget previousCard;

  Future loadMenu() async {
    String jsonString = await rootBundle.loadString('assets/knowledge.json');
    var rootTopic = json.decode(jsonString);
    root = new Topic.fromJson(rootTopic);
    drillTopic(root);
  }

  @override
  void initState() {
    previousTopics = new Queue();
    previousCard = new Container();
    loadMenu();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  previousTopic() {
    if (currentTopic == root) {
      topicCard = Container();
      previousCard = Container();
      return;
    }

    changeTopic(previousTopics.removeLast());
    previousCard =
        previousTopics.isEmpty ? Container() : changeCard(previousTopics.last);
    topicCard = changeCard(currentTopic);
  }

  drillTopic(Topic topic) {
    if (currentTopic != null) {
      previousTopics.add(currentTopic);
    }

    previousCard =
        previousTopics.isEmpty ? Container() : changeCard(previousTopics.last);
    changeTopic(topic);
    topicCard = changeCard(currentTopic);
  }

  changeTopic(Topic topic) {
    currentTopic = topic;
    subTopics = currentTopic.subTopics;
    questions = currentTopic.questions;
    setState(() {});
  }

  MainTopic changeCard(Topic currentTopic) {
    _counter++;
    return MainTopic(
        child: Container(),
        currentTopic: currentTopic,
        navigateBack: currentTopic == root
            ? null
            : () => setState(() {
                  previousTopic();
                }));
  }

  @override
  Widget build(BuildContext context) {
    if (root == null) {
      return Container();
    }

    return new Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Stack(children: [
              previousTopics.isNotEmpty ? previousCard : Container(),
              QuickDismissible(
                onDismissed: (direction) {
                  setState(() {
                    previousTopic();
                  });
                },
                dismissThresholds: root == currentTopic
                    ? {DismissDirection.startToEnd: 1.1}
                    : {DismissDirection.startToEnd: 0.4},
                direction: DismissDirection.startToEnd,
                key: new ValueKey(_counter),
                child: topicCard,
              ),
            ]),
          ),
          SubMenu(
            questions: questions,
            subTopics: subTopics,
            maxAvailableHeight: maxAvailableHeight,
            navigateDown: drillTopic,
          ),
        ],
      ),
    );
  }
}
