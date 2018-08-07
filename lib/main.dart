import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_study/model/question.dart';
import 'package:infinity_study/model/topic.dart';

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

  Queue previousTopics;
  Topic currentTopic;
  List<Topic> subTopics;
  List<Question> questions;

  Future loadMenu() async {
    String jsonString = await rootBundle.loadString('assets/knowledge.json');
    var rootTopic = json.decode(jsonString);
    root = new Topic.fromJson(rootTopic);
    previousTopics.add(root);
    initializeTopic(root);
  }

  @override
  void initState() {
    previousTopics = new Queue();
    loadMenu();
    super.initState();
  }

  previousTopic() {
    if(currentTopic == root)
    {
      return;
    }

    currentTopic = previousTopics.removeLast();
    subTopics = currentTopic.subTopics;
    questions = currentTopic.questions;
    setState(() {});
  }

  initializeTopic(Topic topic) {
    previousTopics.add(currentTopic);
    currentTopic = topic;
    subTopics = currentTopic.subTopics;
    questions = currentTopic.questions;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: new ListView.builder(
              itemCount: questions.length,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(12.0),
              itemBuilder: (BuildContext context, int index) {
                return new Card(
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: new Text(
                        questions[index].question,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () { previousTopic();},
              child: new Container(
                height: 200.0,
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                child: new Card(
                  child: Container(
                    alignment: Alignment.center,
                    child: new Text(
                      currentTopic.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: new ListView.builder(
              itemCount: subTopics.length,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(12.0),
              itemBuilder: (BuildContext context, int index) {
                return new GestureDetector(
                  onTap: () { initializeTopic(subTopics[index]);},
                  child: new Card(
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: new Text(
                          subTopics[index].name,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
