import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_study/core/quickDismissible.dart';
import 'package:infinity_study/main_topic.dart';
import 'package:infinity_study/model/question.dart';
import 'package:infinity_study/questions_menu.dart';
import 'package:infinity_study/model/topic.dart';
import 'package:infinity_study/subtopics_menu.dart';

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

class _CoreAppState extends State<CoreApp> with SingleTickerProviderStateMixin {
  Topic root;
  bool dataLoaded = false;
  bool isExpanded = false;

  Queue previousTopics;
  Topic currentTopic;
  List<Topic> subTopics;
  List<Question> questions;
  double maxAvailableHeight = 500.0;
  int _counter = 0;

  TabController controller;

  Widget topicCard;
  Queue<Widget> previousTopicsCards;

  Future loadMenu() async {
    String jsonString = await rootBundle.loadString('assets/knowledge.json');
    var rootTopic = json.decode(jsonString);
    root = new Topic.fromJson(rootTopic);
    previousTopics.add(root);
    drillTopic(root);
    initializeCard();
  }

  @override
  void initState() {
    previousTopics = new Queue();
    previousTopicsCards = new Queue<Widget>();
    loadMenu();
    controller = new TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  previousTopic() {
    if (currentTopic == root) {
      return;
    }

    changeTopic(previousTopics.removeLast());
    previousTopicsCards.removeLast();
    initializeCard();
  }

  drillTopic(Topic topic) {
    previousTopics.add(currentTopic);
    changeTopic(topic);
    previousTopicsCards.add(topicCard);
    initializeCard();
  }

  changeTopic(Topic topic) {
    currentTopic = topic;
    subTopics = currentTopic.subTopics;
    questions = currentTopic.questions;
    //setState(() {});
  }

  double availableHeight() => isExpanded ? maxAvailableHeight : 0.0;

  double _animatedHeight = 0.0;
  Duration _subMenuDuration = new Duration(milliseconds: 400);
  Curve _curve = Curves.easeInOut;

  void initializeCard() {
    _counter++;
    topicCard = MainTopic(
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
              previousTopicsCards.length > 1 ? previousTopicsCards.last : Container(),
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
          AnimatedContainer(
            height: _animatedHeight * availableHeight(),
            duration: _subMenuDuration,
            curve: _curve,
            child: TabBarView(
              controller: controller,
              children: <Widget>[
                Container(
                  color: Color(0xFFFFFFDD),
                  child: SubTopicsMenu(
                    height: availableHeight(),
                    topics: subTopics,
                    callback: (index) => setState(() {
                          drillTopic(index);
                        }),
                  ),
                ),
                Container(
                  color: Color(0xFFEFF4FF),
                  child: QuestionsMenu(
                      height: availableHeight(),
                      questions: questions,
                      callback: () {
                        setState(() {});
                      }),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              DefaultTabController(
                length: 2,
                child: TabBar(
                  controller: controller,
                  tabs: [
                    Container(),
                    Container(),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  isExpanded = !isExpanded;
                  setState(() {
                    _animatedHeight = isExpanded ? 1.0 : 0.0;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2 -
                          (controller.animation.value - 0.5) * 150,
                      child: AnimatedContainer(
                        duration: _subMenuDuration,
                        curve: _curve,
                        alignment: Alignment.center,
                        color: Color.lerp(Color(0xFFFFFFCC), Color(0xFFFFFF33),
                            _animatedHeight),
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
                        duration: _subMenuDuration,
                        curve: _curve,
                        color: Color.lerp(Color(0xFFDDEEFF), Color(0xFF55AAFF),
                            _animatedHeight),
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
