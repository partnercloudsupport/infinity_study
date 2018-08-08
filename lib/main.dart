import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_study/countdown_timer.dart';
import 'package:infinity_study/flip_card.dart';
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
  bool isExpandedTopics = false;
  bool isExpandedQuestions = false;
  bool isQuizMode = false;
  Stopwatch stopwatch = new Stopwatch();
  Stopwatch stopwatch2 = new Stopwatch();

  Queue previousTopics;
  Topic currentTopic;
  List<Topic> subTopics;
  List<Question> questions;
  double maxAvailableHeight = 300.0;

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
    super.initState();
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
    if (isExpandedQuestions && isExpandedTopics) {
      return maxAvailableHeight / 2;
    } else if ((!isExpandedQuestions && isExpandedTopics) ||
        (isExpandedQuestions && !isExpandedTopics)) {
      return maxAvailableHeight;
    } else {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          !isQuizMode
              ? GestureDetector(
                  child: FlipCard(
                    text: "Questions",
                    color:
                        isExpandedQuestions ? Color(0x10000000) : Colors.white,
                    margin: EdgeInsets.all(0.0),
                    padding: EdgeInsets.symmetric(vertical: 6.0),
                    align: Alignment.center,
                  ),
                  onTap: () {
                    isExpandedQuestions = !isExpandedQuestions;
                    setState(() {});
                  },
                )
              : Container(),
          !isQuizMode
              ? isExpandedQuestions
                  ? QuestionsMenu(
                      height: availableHeight(),
                      questions: questions,
                      callback: () {
                        setState(() {});
                      })
                  : Container()
              : Container(),
          Expanded(
            flex: 1,
            child: MainTopic(
              currentTopic: currentTopic,
              navigateBack: currentTopic == root ? null : previousTopic,
              flipCard: () {
                currentTopic.isBack = !currentTopic.isBack;
                setState(() {});
              },
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
          isExpandedTopics
              ? SubTopicsMenu(
                  height: availableHeight(),
                  topics: subTopics,
                  callback: drillTopic)
              : Container(),
          GestureDetector(
            child: FlipCard(
              text: "Sub Topics",
              color: isExpandedTopics ? Color(0x10000000) : Colors.white,
              margin: EdgeInsets.all(0.0),
              padding: EdgeInsets.symmetric(vertical: 6.0),
              align: Alignment.center,
            ),
            onTap: () {
              isExpandedTopics = !isExpandedTopics;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
