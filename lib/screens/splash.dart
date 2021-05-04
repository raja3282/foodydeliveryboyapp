import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foody_delivery_boy_app/welcome/welcome.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(
        Duration(seconds: 4),
        () => (Navigator.pushReplacement(
            context,
            PageTransition(
                child: Welcome(),
                type: PageTransitionType.leftToRightWithFade))));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 160,
            width: 400,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Lottie.asset('animation/animation.json'),
            ),
          ),
          RichText(
              text: TextSpan(
                  text: 'F',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 56,
                  ),
                  children: <TextSpan>[
                TextSpan(
                  text: 'OO',
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 56,
                  ),
                ),
                TextSpan(
                  text: 'DY',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 56,
                  ),
                ),
              ]))
        ],
      ),
    );
  }
}
