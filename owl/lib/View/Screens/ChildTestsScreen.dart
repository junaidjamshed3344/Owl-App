import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/Model/Variables.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';
import 'package:owl/View/Model/ViewVariables.dart';
import 'package:owl/View/Widgets/IntroGuide.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'ChildMCQsScreen.dart';

class ChildTestsScreen extends StatefulWidget {
  @override
  _ChildTestsScreenState createState() => _ChildTestsScreenState();
}

class _ChildTestsScreenState extends State<ChildTestsScreen> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void initState() {
    super.initState();
    if (Variables.testsList.length < 1) {
      Controller.testsListInitialize(1);
    }
    ViewVariables.childTestScreenRefresh = () {
      setState(() {});
    };
    Future.delayed(const Duration(seconds: 1), () {
      checkIntroGuide();
    });
  }

  void checkIntroGuide() {
    if (Controller.getChildTestIntroStatus()) {
      IntroGuide.childTestIntro.start(context);
    }
  }

  Widget getTestsListView() {
    return SmartRefresher(
      controller: refreshController,
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: () {
        Controller.testsListInitialize(1);
        refreshController.refreshCompleted();
      },
      header: WaterDropMaterialHeader(),
      child: ListView.builder(
        itemCount: Controller.getTestsList().length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.all(SizeConfig.fiveMultiplier),
          child: Container(
            key: index == 0 ? IntroGuide.childTestIntro.keys[0] : Key(""),
            decoration: BoxDecoration(
              color: Controller.getTestsList()[index].isActive
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(SizeConfig.tenMultiplier),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0.5,
                  blurRadius: 6,
                  offset: Offset(3, 6),
                )
              ],
            ),
            padding: EdgeInsets.all(SizeConfig.tenMultiplier),
            child: ListTile(
              leading: Controller.getTestsList()[index].isActive
                  ? CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      child: Icon(
                        Icons.check_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        Icons.storage,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
              title: Text(
                Controller.getTestsList()[index].name,
                style: Controller.getTestsList()[index].isActive
                    ? Theme.of(context).textTheme.bodyText1
                    : Theme.of(context).textTheme.bodyText2,
              ),
              subtitle: Text(
                "${LabelsClass.reward(context)}: ${Controller.getTestsList()[index].rewardMinutes} ${LabelsClass.minutes(context)}",
                style: Controller.getTestsList()[index].isActive
                    ? Theme.of(context).textTheme.headline5
                    : Theme.of(context).textTheme.headline6,
              ),
              trailing: Container(
                child: Controller.getTestsList()[index].isActive
                    ? ElevatedButton(
                        child: Text(LabelsClass.startTest(context)),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.green[300]),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {
                          if (Controller.getTestsList()[index].isActive) {
                            setState(() {
                              Controller.getTestsList()[index].isActive = false;
                              Controller.updateTest(
                                  Controller.getTestsList()[index], index);
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChildMCQsScreen(
                                    Controller.getTestsList()[index]),
                              ),
                            );
                          }
                        },
                      )
                    : Text(""),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.twentyMultiplier),
              topRight: Radius.circular(SizeConfig.twentyMultiplier)),
        ),
        child: getTestsListView(),
      ),
    );
  }
}
