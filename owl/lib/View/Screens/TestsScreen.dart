import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/Model/Test.dart';
import 'package:owl/Model/Variables.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';
import 'package:owl/View/Model/ViewVariables.dart';
import 'package:owl/View/Screens/MCQsScreen.dart';
import 'package:owl/View/Widgets/DeleteDialog.dart';
import 'package:owl/View/Widgets/IntroGuide.dart';
import 'package:owl/View/Widgets/TestAddDialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TestsScreen extends StatefulWidget {
  @override
  _TestsScreenState createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void initState() {
    super.initState();
    if (Variables.testsList.length < 1) {
      Controller.testsListInitialize(0);
    }
    ViewVariables.testScreenRefresh = () {
      setState(() {});
    };
    Future.delayed(const Duration(seconds: 1), () {
      checkIntroGuide();
    });
  }

  void checkIntroGuide() {
    if (Controller.getTestsIntroStatus()) {
      IntroGuide.testsIntro.start(context);
    }
  }

  Future<dynamic> displayDeleteDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteDialog(LabelsClass.sureDeleteTest(context));
      },
    );
  }

  Widget getTestsListView() {
    return SmartRefresher(
      controller: refreshController,
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: () {
        Controller.testsListInitialize(0);
        refreshController.refreshCompleted();
      },
      header: WaterDropMaterialHeader(),
      child: ListView.builder(
        itemCount: Controller.getTestsList().length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.all(SizeConfig.fiveMultiplier),
          child: Dismissible(
            key: Key(Controller.getTestsList()[index].id),
            direction: DismissDirection.horizontal,
            background: Container(
              color: Colors.redAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(LabelsClass.delete(context),
                        style: TextStyle(
                          color: Colors.red[900],
                          fontSize: SizeConfig.twentyMultiplier,
                        )),
                  ),
                  Icon(
                    Icons.delete,
                    color: Colors.red[900],
                  ),
                ],
              ),
            ),
            secondaryBackground: Container(
              color: Colors.redAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(LabelsClass.delete(context),
                      style: TextStyle(
                        color: Colors.red[900],
                        fontSize: SizeConfig.twentyMultiplier,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.delete,
                      color: Colors.red[900],
                    ),
                  ),
                ],
              ),
            ),
            confirmDismiss: (direction) async {
              return await displayDeleteDialog();
            },
            onDismissed: (direction) {
              setState(() {
                Controller.deleteTest(Controller.getTestsList()[index], index);
              });
            },
            child: GestureDetector(
              key: index == 0 ? IntroGuide.testsIntro.keys[0] : Key(""),
              child: Container(
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
                  trailing: GestureDetector(
                    key: index == 0 ? IntroGuide.testsIntro.keys[1] : Key(""),
                    child: Controller.getTestsList()[index].isActive
                        ? CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.clear,
                              color: Theme.of(context).accentColor,
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(
                              Icons.check,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                    onTap: () {
                      setState(() {
                        if (Controller.getTestsList()[index].isActive) {
                          Controller.getTestsList()[index].isActive = false;
                        } else {
                          Controller.getTestsList()[index].isActive = true;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              LabelsClass.testIsActive(context),
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                            duration: Duration(seconds: 3),
                            backgroundColor: Theme.of(context).primaryColor,
                          ));
                        }
                        Controller.updateTest(
                            Controller.getTestsList()[index], index);
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MCQsScreen(Controller.getTestsList()[index]),
                      ),
                    );
                  },
                ),
              ),
              onLongPress: () async {
                Test tempTest = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return TestAddDialog(
                        oldTest: Controller.getTestsList()[index]);
                  },
                );
                if (tempTest != null) {
                  tempTest.id = Controller.getTestsList()[index].id;
                  setState(() {
                    Controller.updateTest(tempTest, index);
                  });
                }
              },
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
