import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/Model/Profile.dart';
import 'package:owl/Model/TimeSlot.dart';
import 'package:owl/View/Model/ViewVariables.dart';
import 'package:owl/View/Screens/AppListScreen.dart';
import 'package:owl/View/Widgets/IntroGuide.dart';
import 'package:owl/View/Widgets/TimeRange.dart';

import '../Model/LabelsClass.dart';
import '../Model/SizeConfig.dart';

class ProfileDataInputScreen extends StatefulWidget {
  final Profile oldProfile;
  int index;

  ProfileDataInputScreen(this.oldProfile, [this.index]);

  @override
  _ProfileDataInputScreenState createState() => _ProfileDataInputScreenState();
}

class _ProfileDataInputScreenState extends State<ProfileDataInputScreen> {
  bool isNew = false;
  Profile tempProfile = new Profile();
  ScrollController scrollViewController = ScrollController();
  bool toBottom = true;
  bool showScrollButton = false;
  List<String> tempDayStatus;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    scrollViewController = ScrollController();
    scrollViewController.addListener(_scrollListener);
    super.initState();

    tempProfile.copyProfile(widget.oldProfile);

    if (tempProfile.name.length > 0) {
      isNew = false;
    } else {
      isNew = true;
    }

    //ViewVariables.profileDataInputScreenToTempDays=new List<String>();
    ViewVariables.profileDataInputScreenToTempDays = [];
    if (tempProfile.days.length > 0) {
      for (int a = 0; a < tempProfile.days.length; a++) {
        ViewVariables.profileDataInputScreenToTempDays.add(
            Controller.profileDataInputScreenToConvertDayKey(
                tempProfile.days[a]));
      }
    } else {
      for (int a = 1; a <= 7; a++) {
        String day =
            Controller.profileDataInputScreenToConvertDayKey(a.toString());
        if (Controller.profileDataInputScreenToCheckDayStatus(day) == false) {
          ViewVariables.profileDataInputScreenToTempDays.add(day);
          tempProfile.days
              .add(Controller.profileDataInputScreenToConvertDayInteger(day));
        }
      }
    }

    ViewVariables.profileDataInputScreenRefresh = () {
      setState(() {});
    };
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => Controller.profileDataInputScreenToInitializeAppsList());

    Future.delayed(const Duration(seconds: 1), () {
      checkIntroGuide();
    });
  }

  void checkIntroGuide() {
    if (Controller.getAddProfileIntroStatus()) {
      IntroGuide.addProfileIntro.start(context);
    }
  }

  Widget getHeightSizeBox(double height) {
    return SizedBox(
      height: height,
    );
  }

  Widget getWidthSizeBox(double width) {
    return SizedBox(
      width: width,
    );
  }

  Decoration getBoxDecoration(double radius) {
    return BoxDecoration(
      color: Theme.of(context).accentColor,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 0.5,
          blurRadius: 6,
          offset: Offset(3, 6),
        )
      ],
    );
  }

  Widget getCircleAvatar() {
    return CircleAvatar(
      backgroundColor: Theme.of(context).buttonColor,
      child: Icon(
        Icons.add,
        color: Theme.of(context).accentColor,
        size: SizeConfig.twentyMultiplier,
      ),
    );
  }

  Widget getDayCircleAvatar(day, bgColor) {
    if (bgColor == Theme.of(context).primaryColor) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 3),
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: SizeConfig.widthEighteenMultiplier,
          backgroundColor: Colors.white,
          child: Text(
            getTranslatedDay(day),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: SizeConfig.fifteenMultiplier,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: bgColor, width: 3),
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: SizeConfig.widthEighteenMultiplier,
          backgroundColor: bgColor,
          child: Text(
            getTranslatedDay(day),
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      );
    }
  }

  String getTranslatedDay(String day) {
    if (day == 'Mo') {
      return LabelsClass.monday(context);
    } else if (day == 'Tu') {
      return LabelsClass.tuesday(context);
    } else if (day == 'We') {
      return LabelsClass.wednesday(context);
    } else if (day == 'Th') {
      return LabelsClass.thursday(context);
    } else if (day == 'Fr') {
      return LabelsClass.friday(context);
    } else if (day == 'Sa') {
      return LabelsClass.saturday(context);
    } else if (day == 'Su') {
      return LabelsClass.sunday(context);
    } else {
      return '-';
    }
  }

  _scrollListener() {
    if (scrollViewController.offset >=
            scrollViewController.position.maxScrollExtent &&
        !scrollViewController.position.outOfRange) {
      setState(() {
        toBottom = true;
      });
    }
    if (scrollViewController.offset <=
            scrollViewController.position.minScrollExtent &&
        !scrollViewController.position.outOfRange) {
      setState(() {
        toBottom = false;
      });
    }
  }

  moveToTop() {
    scrollViewController.animateTo(0,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  moveToBottom() {
    scrollViewController.animateTo(
        scrollViewController.position.maxScrollExtent,
        curve: Curves.linear,
        duration: Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    super.dispose();
    scrollViewController.dispose();
  }

  Widget profileNameSection() {
    return Container(
      key: IntroGuide.addProfileIntro.keys[0],
      height: SizeConfig.sixtyMultiplier,
      padding: EdgeInsets.fromLTRB(
          SizeConfig.fortyMultiplier,
          SizeConfig.tenMultiplier,
          SizeConfig.fortyMultiplier,
          SizeConfig.tenMultiplier),
      child: Form(
        key: formKey,
        child: TextFormField(
          initialValue: tempProfile.name.length > 0 ? tempProfile.name : null,
          autofocus: false,
          style: Theme.of(context).textTheme.headline4,
          textAlign: TextAlign.center,
          onChanged: (value) {
            tempProfile.name = value;
          },
          decoration: InputDecoration(
            hintText: tempProfile.name.length > 0
                ? null
                : LabelsClass.profileName(context),
            hintStyle: TextStyle(fontSize: SizeConfig.twentyMultiplier),
            errorStyle: TextStyle(
              fontSize: SizeConfig.twelveMultiplier,
            ),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return LabelsClass.profileNameError01(context);
            } else if (value.length > 20) {
              return LabelsClass.maxInput20(context);
            }
            return null;
          },
        ),
      ),
      decoration: getBoxDecoration(SizeConfig.tenMultiplier),
    );
  }

  Widget profileModeSection() {
    return Container(
      key: IntroGuide.addProfileIntro.keys[1],
      height: SizeConfig.fiftyMultiplier,
      padding: EdgeInsets.only(
          left: SizeConfig.twentyMultiplier, right: SizeConfig.fiveMultiplier),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tempProfile.blacklist == 0
                ? LabelsClass.blacklistApps(context)
                : LabelsClass.whitelistApps(context),
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Tooltip(
            message: LabelsClass.selectBlockingMode(context),
            preferBelow: true,
            showDuration: Duration(seconds: 1),
            child: Switch(
              activeColor: Colors.black,
              inactiveThumbColor: Colors.white,
              value: tempProfile.blacklist == 0 ? true : false,
              onChanged: (value) {
                setState(() {
                  if (tempProfile.blacklist == 1) {
                    tempProfile.blacklist = 0;
                  } else {
                    tempProfile.blacklist = 1;
                  }
                });
              },
            ),
          ),
        ],
      ),
      decoration: getBoxDecoration(SizeConfig.tenMultiplier),
    );
  }

  Widget selectedAppsSection() {
    return Container(
      key: IntroGuide.addProfileIntro.keys[2],
      height: SizeConfig.oneFiftyMultiplier,
      padding: EdgeInsets.only(
        left: SizeConfig.twentyMultiplier,
        right: SizeConfig.twentyMultiplier,
        top: SizeConfig.tenMultiplier,
      ),
      decoration: getBoxDecoration(SizeConfig.tenMultiplier),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LabelsClass.selectApps(context),
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.left,
                ),
                GestureDetector(
                  onTap: () {
                    ///////// Implement SELECT APPS
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext) =>
                            AppListScreen(tempProfile.appList),
                      ),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    child: getCircleAvatar(),
                    decoration: getBoxDecoration(SizeConfig.fiftyMultiplier),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: SizeConfig.fortyMultiplier,
              child: ListView.separated(
                itemCount: tempProfile.appList.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (BuildContext context, int index) =>
                    VerticalDivider(
                  width: 3,
                  color: Theme.of(context).accentColor,
                ),
                itemBuilder: (context, index) {
                  return CircleAvatar(
                    backgroundColor: Theme.of(context).accentColor,
                    child: tempProfile.appList[index].appIcon,
                  );
                },
              ),
            ),
          ),
          getHeightSizeBox(SizeConfig.tenMultiplier),
        ],
      ),
    );
  }

  Widget timeSlotsSection() {
    return Container(
      height: SizeConfig.threeFiftyMultiplier,
      padding: EdgeInsets.only(
        left: SizeConfig.twentyMultiplier,
        right: SizeConfig.twentyMultiplier,
        top: SizeConfig.tenMultiplier,
      ),
      decoration: getBoxDecoration(SizeConfig.tenMultiplier),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LabelsClass.duration(context),
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.left,
                ),
                Row(
                  key: IntroGuide.addProfileIntro.keys[3],
                  children: [
                    GestureDetector(
                      onTap: () {
                        ///////// Implement SELECT TIME
                        tempProfile.timeSlots.clear();
                        final now = new DateTime.now();
                        tempProfile.timeSlots.add(TimeSlot(
                          startTime:
                              DateTime(now.year, now.month, now.day, 0, 0, 0),
                          //TimeOfDay(hour: 0 , minute: 0)
                          endTime:
                              DateTime(now.year, now.month, now.day, 23, 59, 0),
                        )); //DateTime.parse("2020-11-02 23:59:00Z")
                        ViewVariables.profileDataInputScreenRefresh.call();
                      },
                      child: Container(
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).buttonColor,
                          child: Text(
                            '24H',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        decoration:
                            getBoxDecoration(SizeConfig.fiftyMultiplier),
                      ),
                    ),
                    getWidthSizeBox(SizeConfig.fiveMultiplier),
                    GestureDetector(
                      onTap: () {
                        ///////// Implement SELECT TIME
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return TimeRange(tempProfile.timeSlots);
                          },
                        );
                      },
                      child: Container(
                        child: getCircleAvatar(),
                        decoration:
                            getBoxDecoration(SizeConfig.fiftyMultiplier),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              key: IntroGuide.addProfileIntro.keys[4],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                getDayWidget("Mo"),
                getDayWidget("Tu"),
                getDayWidget("We"),
                getDayWidget("Th"),
                getDayWidget("Fr"),
                getDayWidget("Sa"),
                getDayWidget("Su"),
              ],
            ),
          ),
          Container(
            height: SizeConfig.oneSeventyFiveMultiplier,
            padding: EdgeInsets.only(bottom: SizeConfig.fiveMultiplier),
            child: Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Container(
                height: SizeConfig.thirtyMultiplier,
                child: showScrollButton
                    ? FloatingActionButton(
                        backgroundColor: Theme.of(context).buttonColor,
                        child: Icon(
                          toBottom
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () {
                          if (toBottom) {
                            moveToBottom();
                          } else {
                            moveToTop();
                          }
                        },
                      )
                    : null,
              ),
              body: NotificationListener(
                onNotification: (notification) {
                  if (scrollViewController.position.userScrollDirection ==
                      ScrollDirection.reverse) {
                    setState(() {
                      toBottom = true;
                    });
                  } else {
                    if (scrollViewController.position.userScrollDirection ==
                        ScrollDirection.forward) {
                      setState(() {
                        toBottom = false;
                      });
                    }
                  }

                  if (notification is ScrollStartNotification) {
                    if (!showScrollButton) {
                      setState(() => showScrollButton = true);
                    }
                  } else if (notification is ScrollEndNotification) {
                    if (showScrollButton) {
                      Future.delayed(Duration(milliseconds: 500))
                          .then((_) => setState(() {
                                showScrollButton = false;
                              }));
                    }
                  }

                  return true;
                },
                child: ListView.separated(
                  controller: scrollViewController,
                  itemCount: tempProfile.timeSlots.length,
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    height: SizeConfig.fiveMultiplier,
                  ),
                  itemBuilder: (context, index) {
                    return Dismissible(
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
                                    fontSize: SizeConfig.fifteenMultiplier,
                                  )),
                            ),
                            Icon(
                              Icons.delete,
                              color: Colors.red[900],
                              size: SizeConfig.twentyMultiplier,
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
                                  fontSize: SizeConfig.fifteenMultiplier,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.delete,
                                color: Colors.red[900],
                                size: SizeConfig.twentyMultiplier,
                              ),
                            ),
                          ],
                        ),
                      ),
                      key: Key(tempProfile.timeSlots[index].startTime.hour
                          .toString()),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.fiveMultiplier),
                        child: Align(
                            child: Text(
                          "${Controller.getFormatTime(tempProfile.timeSlots[index].startTime.hour)}:${Controller.getFormatTime(tempProfile.timeSlots[index].startTime.minute)} - ${Controller.getFormatTime(tempProfile.timeSlots[index].endTime.hour)}:${Controller.getFormatTime(tempProfile.timeSlots[index].endTime.minute)} ",
                          style:
                              TextStyle(fontSize: SizeConfig.fifteenMultiplier),
                        )),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          tempProfile.timeSlots.removeAt(index);
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color getDayColor(day) {
    if (tempProfile.days.contains(
            Controller.profileDataInputScreenToConvertDayInteger(day)) ==
        true) {
      return Theme.of(context).buttonColor;
    } else if (Controller.profileDataInputScreenToCheckDayStatus(day) == true) {
      return Theme.of(context).disabledColor;
    } else {
      return Theme.of(context).primaryColor;
    }
  }

  Widget getDayWidget(day) {
    return GestureDetector(
      onTap: () {
        setState(() {
//          if (Controller.profileDataInputScreenToCheckDayStatus(day) == false) {
//            Controller.profileDataInputScreenToSetDayStatus(day, true);
//            ViewVariables.profileDataInputScreenToTempDays.add(day);
//            tempProfile.days
//                .add(Controller.profileDataInputScreenToConvertDayInteger(day));
//          } else
          if (Controller.profileDataInputScreenToCheckDayStatus(day) == false) {
            if (ViewVariables.profileDataInputScreenToTempDays.contains(day)) {
              Controller.profileDataInputScreenToSetDayStatus(day, false);
              ViewVariables.profileDataInputScreenToTempDays.remove(day);
              tempProfile.days.remove(
                  Controller.profileDataInputScreenToConvertDayInteger(day));
            } else {
              ViewVariables.profileDataInputScreenToTempDays.add(day);
              tempProfile.days.add(
                  Controller.profileDataInputScreenToConvertDayInteger(day));
            }
          } else {
            if (ViewVariables.profileDataInputScreenToTempDays.contains(day)) {
              Controller.profileDataInputScreenToSetDayStatus(day, false);
              ViewVariables.profileDataInputScreenToTempDays.remove(day);
              tempProfile.days.remove(
                  Controller.profileDataInputScreenToConvertDayInteger(day));
            }
          }
        });
      },
      child: Container(
        child: getDayCircleAvatar(day, getDayColor(day)),
      ),
    );
  }

  void confirmAllDayStatus() {
    for (int a = 0; a < tempProfile.days.length; a++) {
      Controller.profileDataInputScreenToSetDayStatus(
          Controller.profileDataInputScreenToConvertDayKey(tempProfile.days[a]),
          true);
    }
  }

  Future<bool> _onWillPop() async {
    if (IntroGuide.addProfileIntro.getStatus().isOpen) {
      IntroGuide.addProfileIntro.dispose();
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          title: Text(LabelsClass.newProfile(context),
              style: Theme.of(context).textTheme.headline1),
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.fifteenMultiplier),
                  // This is the main Column with all widgets
                  // This is the main Column with all widgets
                  // This is the main Column with all widgets
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      getHeightSizeBox(SizeConfig.tenMultiplier),
                      profileNameSection(),
                      getHeightSizeBox(SizeConfig.tenMultiplier),
                      profileModeSection(),
                      getHeightSizeBox(SizeConfig.tenMultiplier),
                      selectedAppsSection(),
                      getHeightSizeBox(SizeConfig.tenMultiplier),
                      timeSlotsSection(),
                      getHeightSizeBox(SizeConfig.tenMultiplier),
                      /*RaisedButton(
                          color: Theme.of(context).buttonColor,
                          child: Text(
                            LabelsClass.saveProfile(context),
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          onPressed: () async {
                            // save profile here
                            tempProfile.status = 1;
                            tempProfile.printProfile();

                            if (isNew) {

                              await Controller.addProfileScreenToAddProfile(profile: tempProfile);

                            } else {
                              */ /*Controller.addProfileScreenToUpdateProfile(
                                  profile: tempProfile,
                              index: index);*/ /*
                              print(widget.index);

                              //await Controller.profileScreenToDeleteProfile(index: widget.index);
                              //widget.tempProfile.id=null;
                              //await Controller.addProfileScreenToAddProfile(profile: widget.tempProfile);
                              await Controller.addProfileScreenToUpdateProfile(profile: widget.tempProfile, index: widget.index);

                            }

                            ViewVariables.profileScreenRefresh.call();
                            Controller.profileDataInputScreenToSaveDayStatus();
                            Navigator.of(context).pop();
                          },
                        ),
                        getHeightSizeBox(SizeConfig.tenMultiplier),*/
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            key: IntroGuide.addProfileIntro.keys[5],
            backgroundColor: Theme.of(context).buttonColor,
            child: Icon(Icons.check_rounded),
            onPressed: () async {
              if (formKey.currentState.validate()) {
                if (tempProfile.isComplete() == true) {
                  // save profile here
                  tempProfile.status = 1;
                  tempProfile.printProfile();

                  if (isNew) {
                    await Controller.addProfileScreenToAddProfile(
                        profile: tempProfile);
                  } else {
                    await Controller.addProfileScreenToUpdateProfile(
                        profile: tempProfile, index: widget.index);
                    print(widget.index);
                    /*await Controller.profileScreenToDeleteProfile(
                        index: widget.index);
                    await Controller.addProfileScreenToAddProfile(
                        profile: tempProfile);*/
                  }
                  confirmAllDayStatus();
                  ViewVariables.profileScreenRefresh.call();
                  Controller.profileDataInputScreenToSaveDayStatus();
                  Navigator.of(context).pop();
                } else {
                  final snackBar = SnackBar(
                    content: Text(
                      LabelsClass.allFieldsAreRequired(context),
                    ),
                    duration: Duration(milliseconds: 1000),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
