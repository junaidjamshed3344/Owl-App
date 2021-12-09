import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/View/Model/AuthenticationWrapper.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';
import 'package:owl/View/Screens/ChildRewardsScreen.dart';
import 'package:owl/View/Screens/InputPIN.dart';
import 'package:owl/View/Screens/SignUpSignInScreen.dart';
import 'package:owl/View/Widgets/IntroGuide.dart';
import 'package:owl/View/Widgets/SureDialog.dart';

import 'ChildTestsScreen.dart';

class LockScreen extends StatefulWidget {
  @override
  _LockScreen createState() => _LockScreen();
}

class _LockScreen extends State<LockScreen> {
  int tabNumber = 0;

  @override
  void initState() {
    super.initState();
  }

  String getTitle() {
    if (tabNumber == 0) {
      return LabelsClass.myRewards(context);
    } else if (tabNumber == 1) {
      return "MCQs";
    } else {
      return LabelsClass.lockScreen(context);
    }
  }

  Future<bool> _onWillPop() async {
    if (IntroGuide.childRewardIntro.getStatus().isOpen) {
      IntroGuide.childRewardIntro.dispose();
      return false;
    } else if (IntroGuide.childTestIntro.getStatus().isOpen) {
      IntroGuide.childTestIntro.dispose();
      return false;
    } else {
      bool result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SureDialog(LabelsClass.sureExit(context));
        },
      );
      if (result == true) {
        exit(0);
      } else {
        return null;
      }
    }
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'images/blinking.gif',
                  fit: BoxFit.contain,
                  height: SizeConfig.fortyMultiplier,
                ),
                Container(
                  color: Theme.of(context).primaryColor,
                  padding:
                      EdgeInsets.symmetric(vertical: SizeConfig.tenMultiplier),
                  child: Center(
                    child: Text(
                      getTitle(),
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ),
                Image.asset(
                  'images/owl_hidden.png',
                  fit: BoxFit.contain,
                  height: SizeConfig.fortyMultiplier,
                ),
              ],
            ),
            bottom: TabBar(
              onTap: (value) {
                setState(() {
                  if (tabNumber != value) {
                    tabNumber = value;
                  }
                });
                /*if (value == 2) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthenticationWrapper(),
                      ));
                }*/
              },
              tabs: [
                Tab(
                    icon: Icon(
                  Icons.card_giftcard,
                )),
                Tab(
                    icon: Icon(
                  Icons.storage,
                )),
                Tab(
                    icon: Icon(
                  Icons.fiber_pin,
                )),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(), // to stop from changing on swipe
            children: [
              ChildRewardsScreen(),
              ChildTestsScreen(),
              InputPIN(0),
            ],
          ),
        ),
      ),
    );
  }
}
