import 'package:flutter/material.dart';
import 'package:infinity_study/model/question.dart';
import 'package:infinity_study/model/topic.dart';
import 'package:infinity_study/questions_menu.dart';
import 'package:infinity_study/subtopics_menu.dart';
import 'package:infinity_study/tab_menu.dart';

class SubMenu extends StatefulWidget {
  final double maxAvailableHeight;
  final List<Topic> subTopics;
  final List<Question> questions;
  final Function navigateDown;

  SubMenu(
      {this.questions,
      this.subTopics,
      this.maxAvailableHeight,
      this.navigateDown});

  @override
  _SubMenuState createState() => _SubMenuState();
}

class _SubMenuState extends State<SubMenu> with SingleTickerProviderStateMixin {
  TabController controller;
  double _animatedHeight = 0.0;
  Duration _subMenuDuration = new Duration(milliseconds: 400);
  Curve _curve = Curves.easeInOut;
  bool isExpanded = false;

  double availableHeight() => isExpanded ? widget.maxAvailableHeight : 0.0;

  @override
  initState() {
    controller = new TabController(length: 2, vsync: this);
    controller.animation.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          height: _animatedHeight * widget.maxAvailableHeight,
          duration: _subMenuDuration,
          curve: _curve,
          child: TabBarView(
            controller: controller,
            children: <Widget>[
              Container(
                color: Color(0xFFFFFFDD),
                child: SubTopicsMenu(
                  height: widget.maxAvailableHeight,
                  topics: widget.subTopics,
                  callback: (index) => setState(() {
                        widget.navigateDown(index);
                      }),
                ),
              ),
              Container(
                color: Color(0xFFEFF4FF),
                child: QuestionsMenu(
                    height: widget.maxAvailableHeight,
                    questions: widget.questions,
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
              child: new TabMenu(
                  controller: controller,
                  subMenuDuration: _subMenuDuration,
                  curve: _curve,
                  animatedHeight: _animatedHeight),
            ),
          ],
        ),
      ],
    );
  }
}
