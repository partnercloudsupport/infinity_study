import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_study/countdown_timer.dart';
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
  bool isQuizMode = false;
  Stopwatch stopwatch = new Stopwatch();
  Stopwatch stopwatch2 = new Stopwatch();

  Queue previousTopics;
  Topic currentTopic;
  List<Topic> subTopics;
  List<Question> questions;
  double maxAvailableHeight = 500.0;

  TabController controller;

  Future loadMenu() async {
    String jsonString = await rootBundle.loadString('assets/knowledge.json');
    var rootTopic = json.decode(jsonString);
    root = new Topic.fromJson(rootTopic);
    previousTopics.add(root);
    drillTopic(root);
  }

  @override
  void initState() {
    previousTopics = new Queue();
    loadMenu();
    controller = new TabController(length: 2, vsync: this);
    controller.index = 1;
    controller.animation.addListener(() {
      if (controller.offset < 0) {
        controller.index = 1;
        previousTopics;
      }
      setState(() {});
    });

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
  }

  drillTopic(Topic topic) {
    previousTopics.add(currentTopic);
    changeTopic(topic);
  }

  changeTopic(Topic topic) {
    currentTopic = topic;
    subTopics = currentTopic.subTopics;
    questions = currentTopic.questions;
    setState(() {});
  }

  double availableHeight() {
    return isExpanded ? maxAvailableHeight : 0.0;
  }

  double _animatedHeight = 0.0;
  Duration _subMenuDuration = new Duration(milliseconds: 400);
  Curve _curve = Curves.easeInOut;

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
            child: MainTopic(
              currentTopic: currentTopic,
              navigateBack: currentTopic == root ? null : previousTopic,
              child: Stack(
                children: <Widget>[
                  isQuizMode
                      ? Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CountdownTimer(
                              stopwatch: stopwatch2,
                              duration: Duration(seconds: 30),
                            ),
                          ),
                        )
                      : new Container(),
                  !isQuizMode
                      ? Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: new Icon(
                              Icons.timer,
                              color: Color(0x99000000),
                            ),
                            onPressed: () {
                              isQuizMode = true;
                              stopwatch.start();
                              stopwatch2.start();
                              setState(() {});
                            },
                          ),
                        )
                      : Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: new Icon(
                              Icons.timer_off,
                              color: Color(0x99000000),
                            ),
                            onPressed: () {
                              isQuizMode = false;
                              stopwatch.stop();
                              stopwatch.reset();
                              stopwatch2.stop();
                              stopwatch2.reset();
                              setState(() {});
                            },
                          ),
                        ),
                  isQuizMode
                      ? Transform(
                          transform: Matrix4.translationValues(0.0, 32.0, 0.0),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: CountdownTimer(
                                stopwatch: stopwatch,
                                duration: Duration(minutes: 10),
                                textStyle: const TextStyle(
                                    fontSize: 12.0, color: Color(0x88000000)),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
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
                      callback: drillTopic),
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
