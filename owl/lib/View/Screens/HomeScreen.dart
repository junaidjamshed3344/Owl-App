import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/Model/Profile.dart';
import 'package:owl/Model/Test.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';
import 'package:owl/View/Screens/LockScreen.dart';
import 'package:owl/View/Screens/ParentRewardsScreen.dart';
import 'package:owl/View/Screens/ProfileDataInputScreen.dart';
import 'package:owl/View/Screens/ProfilesScreen.dart';
import 'package:owl/View/Screens/SettingsScreen.dart';
import 'package:owl/View/Widgets/IntroGuide.dart';
import 'package:owl/View/Widgets/RewardDataInputDialog.dart';
import 'package:owl/View/Widgets/SureDialog.dart';
import 'package:owl/View/Widgets/TestAddDialog.dart';

import 'TestsScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int bodyPageNumber = 0;
  Function parentScreenRefresh;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      checkIntroGuide();
    });
  }

  void checkIntroGuide() {
    if (Controller.getIntroStatus()) {
      IntroGuide.intro.start(context);
    }
  }

  Widget chooseBodyPage() {
    if (bodyPageNumber == 3) {
      return SettingsScreen();
    } else if (bodyPageNumber == 2) {
      return TestsScreen();
    } else if (bodyPageNumber == 1) {
      return ProfilesScreen();
    } else {
      return ParentRewardsScreen();
    }
  }

  String showTitleText() {
    if (bodyPageNumber == 3) {
      return LabelsClass.settings(context);
    } else if (bodyPageNumber == 2) {
      return LabelsClass.tests(context);
    } else if (bodyPageNumber == 1) {
      return LabelsClass.profiles(context);
    } else {
      return LabelsClass.rewards(context);
    }
  }

  bool showFAB() {
    if (bodyPageNumber == 3) {
      return false;
    } else {
      return true;
    }
  }

  void fabOnPress() {
    print("fab");
    if (bodyPageNumber == 0) {
      displayRewardDataInputDialog();
    } else if (bodyPageNumber == 1) {
      displayProfileDataInputScreen();
    } else {
      displayTestAddDialog();
    }
  }

  Widget centerButton() {
    return Container(
      key: IntroGuide.intro.keys[5],
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).accentColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: Theme.of(context).buttonColor,
      ),
      child: IconButton(
        onPressed: fabOnPress,
        icon: Icon(
          Icons.add,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  Widget getBottomNavigation() {
    if (showFAB()) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          bottomIcon(Icons.card_giftcard, 0),
          bottomIcon(Icons.assignment, 1),
          centerButton(),
          bottomIcon(Icons.storage, 2),
          bottomIcon(Icons.settings, 3),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          bottomIcon(Icons.card_giftcard, 0),
          bottomIcon(Icons.assignment, 1),
          bottomIcon(Icons.storage, 2),
          bottomIcon(Icons.settings, 3),
        ],
      );
    }
  }

  Key getKeyForIntro(int pageNumber) {
    if (pageNumber == 0) {
      return IntroGuide.intro.keys[0];
    } else if (pageNumber == 1) {
      return IntroGuide.intro.keys[1];
    } else if (pageNumber == 2) {
      return IntroGuide.intro.keys[2];
    } else {
      return IntroGuide.intro.keys[3];
    }
  }

  Widget bottomIcon(IconData icon, int pageNumber) {
    return IconButton(
      key: getKeyForIntro(pageNumber),
      onPressed: () {
        setState(() {
          if (bodyPageNumber != pageNumber) {
            bodyPageNumber = pageNumber;
          }
        });
      },
      icon: Icon(
        icon,
        color: Theme.of(context).accentColor,
        size: SizeConfig.thirtyMultiplier,
      ),
    );
  }

  Future<dynamic> displayRewardDataInputDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return RewardDataInputDialog();
      },
    );
  }

  Future<dynamic> displayProfileDataInputScreen() {
    Profile tempProfile = new Profile();
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileDataInputScreen(tempProfile),
      ),
    );
  }

  Future<void> displayTestAddDialog() async {
    Test tempTest = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return TestAddDialog();
      },
    );
    if (tempTest != null) {
      setState(() {
        Controller.addTest(tempTest);
      });
    }
  }

  Future<bool> _onWillPop() async {
    //print("back button pressed");
    if (IntroGuide.intro.getStatus().isOpen) {
      IntroGuide.intro.dispose();
      return false;
    } else if (IntroGuide.profileIntro.getStatus().isOpen) {
      IntroGuide.profileIntro.dispose();
      return false;
    } else if (IntroGuide.testsIntro.getStatus().isOpen) {
      IntroGuide.testsIntro.dispose();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.fiveMultiplier),
            child: Image.asset(
              'images/blinking.gif',
              fit: BoxFit.contain,
              height: SizeConfig.fortyMultiplier,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                padding:
                    EdgeInsets.symmetric(vertical: SizeConfig.tenMultiplier),
                child: Center(
                  child: Text(
                    showTitleText(),
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.fiveMultiplier),
              child: IconButton(
                key: IntroGuide.intro.keys[4],
                icon: Icon(Icons.outbond),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LockScreen(),
                    ),
                  );
                },
              ),
            )
          ],
        ),
        body: chooseBodyPage(),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          notchMargin: SizeConfig.tenMultiplier,
          elevation: SizeConfig.tenMultiplier,
          child: Container(
            height: SizeConfig.sixtyMultiplier,
            child: getBottomNavigation(),
          ),
        ),
        /*floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: showFAB()
            ? FloatingActionButton(
                key: IntroGuide.intro.keys[5],
                onPressed: fabOnPress,
                child: Icon(
                  Icons.add,
                  size: SizeConfig.thirtyMultiplier,
                ),
                backgroundColor: Theme.of(context).buttonColor,
              )
            : null,*/
      ),
    );
  }
}
