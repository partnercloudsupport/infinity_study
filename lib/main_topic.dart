import 'package:flutter/material.dart';
import 'package:infinity_study/main_topic_card.dart';
import 'package:infinity_study/model/topic.dart';

class MainTopic extends StatefulWidget {
  final Topic currentTopic;
  final Function navigateBack;
  final Widget child;

  MainTopic({this.currentTopic, this.navigateBack, this.child});

  @override
  _MainTopicState createState() => _MainTopicState();
}

class _MainTopicState extends State<MainTopic> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _frontScale;
  Animation<double> _backScale;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _frontScale = new Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.0, 0.5, curve: Curves.easeIn),
    ));
    _backScale = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.5, 1.0, curve: Curves.easeOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.currentTopic.isBack = !widget.currentTopic.isBack;
            if (_controller.isCompleted || _controller.velocity > 0)
              _controller.reverse();
            else
              _controller.forward();
          });
        },
        child: Stack(
          children: <Widget>[
            new AnimatedBuilder(
              child: MainTopicCard(
                text: widget.currentTopic.description,
                color: new Color(0x22000000),
                onPressed: widget.navigateBack,
              ),
              animation: _backScale,
              builder: (BuildContext context, Widget child) {
                final Matrix4 transform = new Matrix4.identity()
                  ..scale(_backScale.value, 1.0, 1.0);
                return new Transform(
                  transform: transform,
                  alignment: FractionalOffset.center,
                  child: child,
                );
              },
            ),
            new AnimatedBuilder(
              child: MainTopicCard(
                text: widget.currentTopic.name,
                onPressed: widget.navigateBack,
              ),
              animation: _frontScale,
              builder: (BuildContext context, Widget child) {
                final Matrix4 transform = new Matrix4.identity()
                  ..scale(_frontScale.value, 1.0, 1.0);
                return new Transform(
                  transform: transform,
                  alignment: FractionalOffset.center,
                  child: child,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
