// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new FlutterLogo();
  }
}

class SizeGrowTransition extends StatelessWidget {
  SizeGrowTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (BuildContext context, Widget animatedChild) {
          return new Container(
              height: animation.value,
              width: animation.value,
              child: animatedChild);
        });
  }
}

class TextTransition extends StatelessWidget {
  final Text child;
  final Animation<Color> colorAnimation;
  final Animation<double> sizeAnimation;

  TextTransition({this.child, this.colorAnimation, this.sizeAnimation});

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
        animation: colorAnimation,
        child: child,
        builder: (BuildContext context, Widget animatedChild) {
          return new AnimatedBuilder(
              animation: sizeAnimation,
              child: animatedChild,
              builder: (BuildContext context, Widget animatedChild2) {
                return new Text(child.data,
                    style: child.style.copyWith(
                      color: colorAnimation.value,
                      fontSize: sizeAnimation.value,
                    ));
              });
        });
  }
}

class LogoApp extends StatefulWidget {
  _LogoAppState createState() => new _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  Animation<Color> colorAnimation;
  Animation<double> curveAnimation;
  Animation<double> alpha;
  Animation<double> easeOutAnimation;

  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 300.0).animate(controller)
      ..addListener(() {
//        setState(() {
        //print('hohoho ${animation.value}');
        print('alpha.value = ${alpha.value}');
        print(controller.value);
        // the state that has changed here is the animation object’s value
//        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    colorAnimation = new ColorTween(begin: Colors.lightBlue, end: Colors.red)
        .animate(controller);
    //controller.forward();

    curveAnimation =
        new CurvedAnimation(parent: controller, curve: Curves.easeOut);
    alpha = new Tween(begin: 10.0, end: 100.0).animate(curveAnimation);

    easeOutAnimation = new Tween(begin: 0.0, end: 300.0).animate(
      new CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );
  }

  Widget build(BuildContext context) {
    return new Center(
      child: new Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new IconButton(
                  icon: new Icon(Icons.fast_forward),
                  tooltip: 'Increase volume by 10%',
                  onPressed: () {
                    setState(() {
                      controller.reset();
                      controller.forward();
                    });
                  },
                ),
                new IconButton(
                  icon: new Icon(Icons.fast_rewind),
                  tooltip: 'Increase volume by 10%',
                  onPressed: () {
                    setState(() {
                      controller.reverse(from: 1.0);
                    });
                  },
                ),
                new IconButton(
                  icon: new Icon(Icons.stop),
                  tooltip: 'Increase volume by 10%',
                  onPressed: () {
                    setState(() {
                      //controller.value = 0.5;
                      controller.stop(canceled: false);
                    });
                  },
                ),
              ],
            ),
            new TextTransition(
              child: new Text(
                'testest',
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
              colorAnimation: colorAnimation,
              sizeAnimation: alpha,
            ),
            SizeGrowTransition(
              animation: animation,
              child: Logo(),
            ),
            SizeGrowTransition(
              animation: easeOutAnimation,
              child: Logo(),
            ),
          ],
        ),
      ),
    );
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}

void main() {
  runApp(new MaterialApp(
    home: new Scaffold(
      body: new LogoApp(),
    ),
  ));
}
