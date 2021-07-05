import 'package:flutter/material.dart';

class UnusedSplashScreen extends StatefulWidget {
  @override
  _UnusedSplashScreenState createState() => _UnusedSplashScreenState();
}

class _UnusedSplashScreenState extends State<UnusedSplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween<double>(begin: 10, end: 200).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.repeat(
        //period: Duration(seconds: 3)
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(237, 235, 173, 1),
      body: Center(
        child: Container(
          height: animation.value,
          width: animation.value,
          child: Image.asset("images/Time_tracker/1.png"),
        ),
      ),
    );
  }
}
