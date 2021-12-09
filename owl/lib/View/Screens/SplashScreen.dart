import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/View/Screens/InformationScreen.dart';
import 'package:owl/View/Screens/LockScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => chooseNextScreen(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image.asset(
              'images/splash_screen_gif.gif',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}

Widget chooseNextScreen() {
  int isFirstTime = Controller.splashScreenToIsFirstTime();
  if (isFirstTime == 0) {
    return InformationScreen();
  } else {
    return LockScreen();
  }
}
