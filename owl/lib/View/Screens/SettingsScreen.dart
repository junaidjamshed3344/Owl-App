import 'package:app_block_rit/app_block_rit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/Model/Variables.dart';
import 'package:owl/View/Model/AuthenticationService.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';
import 'package:owl/View/Screens/HelpScreen.dart';
import 'package:owl/View/Screens/InputPIN.dart';
import 'package:owl/View/Widgets/LanguageChangeDialog.dart';
import 'package:owl/View/Widgets/SignOutDialog.dart';
import 'package:owl/View/Widgets/UninstallGuideDialog.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreen createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  int maxUsageLimit = Controller.parentScreenToGetMaxUsageLimit();
  final _auth = FirebaseAuth.instance;
  dynamic user;
  String userEmail;

  /*addData() {
    Map<String, dynamic> demoData = {"name": "RIT", "job" : "Services"};

    CollectionReference collectionReference = FirebaseFirestore.instance.collection('users');
    collectionReference.add(demoData);
  }*/

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> displayLanguageDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return LanguageChangeDialog();
      },
    );
  }

  void setMaxUsageTime(TimeOfDay time) {
    int hours = 0;
    int minutes = 0;
    if (time.hour != null) {
      hours = time.hour;
    }
    if (time.minute != null) {
      minutes = time.minute;
    }
    int totalMinutes = minutes + (hours * 60);
    Controller.parentScreenToSetMaxUsageLimit(totalMinutes);
    setState(() {
      maxUsageLimit = Controller.parentScreenToGetMaxUsageLimit();
    });
  }

  int getHours(int maxLimit) {
    if (maxLimit > 60) {
      return (maxLimit / 60).toInt();
    } else {
      return 0;
    }
  }

  int getMinutes(int maxLimit) {
    if (maxLimit < 60) {
      return maxLimit;
    } else {
      return maxLimit % 60;
    }
  }

  String getCurrentUserInfo() {
    user = _auth.currentUser;
    userEmail = user.email;
    return userEmail;

    /*var firebaseUser = _auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get()
        .then((documentRef) {
          return documentRef.data()["email"];
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Builder(
        builder: (context) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.twentyMultiplier),
                topRight: Radius.circular(SizeConfig.twentyMultiplier)),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.timer,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        LabelsClass.setMaxUsageTime(context),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      onTap: () async {
                        TimeOfDay hoursSelected = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                              hour: getHours(maxUsageLimit),
                              minute: getMinutes(maxUsageLimit)),
                          builder: (BuildContext context, Widget child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child,
                            );
                          },
                          helpText: LabelsClass.setMaxUsageTime(context),
                        );
                        if (hoursSelected != null) {
                          setMaxUsageTime(hoursSelected);
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.fiber_pin,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        LabelsClass.changePinCode(context),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InputPIN(1),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.language,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        LabelsClass.changeLanguage(context),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      onTap: () {
                        displayLanguageDialog();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.admin_panel_settings,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        LabelsClass.uninstallSettings(context),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return UninstallGuideDialog();
                          },
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.assignment_turned_in_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      onTap: () async {
                        // grant usage permission - opens Usage Settings
                        //UsageStats.grantUsagePermission();

                        // check if permission is granted
                        //bool isPermission = await UsageStats.checkUsagePermission();
                        await AppBlockRit.readAppUsagePermission();
                        print(await AppBlockRit.usagePermissionStatus());
                        //print(isPermission);
                        //
                      },
                      title: Text(
                        LabelsClass.readAppUsagePermission(context),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.assignment_turned_in_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      onTap: () async {
                        if (await AppBlockRit.floatingWindowPermission() ==
                            "SDK version smaller than Pie") {
                          final snackBar = SnackBar(
                            content: Text("You don't require this permission"),
                            duration: Duration(milliseconds: 1000),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        print(await AppBlockRit.floatingWindowStatus());
                      },
                      title: Text(
                        LabelsClass.floatingWindowPermission(context),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.bug_report_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        LabelsClass.sendBugReport(context),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      onTap: () async {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            LabelsClass.underConstruction(context),
                          ),
                          duration: Duration(seconds: 3),
                        ));
                        final Email email = Email(
                          body: LabelsClass.describeProblem(context),
                          subject: 'Bug Report',
                          recipients: ['rit.services.backend@gmail.com'],
                          isHTML: false,
                        );

                        await FlutterEmailSender.send(email);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.question_answer,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        LabelsClass.faqs(context),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HelpScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Theme.of(context).primaryColor,
                      ),
                      onTap: () async {
                        bool result = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SignOutDialog(getCurrentUserInfo());
                          },
                        );
                        if (result) {
                          Variables.profileList.clear();
                          Variables.rewardsList.clear();
                          context.read<AuthenticationService>().signOut();
                        }

                        //addData();
                      },
                      title: Text(
                        LabelsClass.signOut(context),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
