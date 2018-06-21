// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 10.0),
      height: animation.value,
      width: animation.value,
      child: new FlutterLogo(),
    );
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
  Animation<int> alpha;
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
        print('status = $status');
      });
    colorAnimation = new ColorTween(begin: Colors.lightBlue, end: Colors.red)
        .animate(controller);
    //controller.forward();

    curveAnimation =
        new CurvedAnimation(parent: controller, curve: Curves.easeOut);
    alpha = new IntTween(begin: 10, end: 100).animate(curveAnimation);

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
            new Text(
              'testest',
              style: new TextStyle(
                  color: colorAnimation.value, fontSize: alpha.value * 1.0),
            ),
            AnimatedLogo(
              animation: animation,
            ),
            AnimatedLogo(
              animation: easeOutAnimation,
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
