import 'dart:convert';

import 'package:app_block_rit/app_block_rit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:owl/Model/App.dart';
import 'package:owl/Model/MCQ.dart';
import 'package:owl/Model/Profile.dart';
import 'package:owl/Model/Reward.dart';
import 'package:owl/Model/SharedPrefs.dart';
import 'package:owl/Model/Test.dart';
import 'package:owl/Model/TimeSlot.dart';
import 'package:owl/Model/Variables.dart';
import 'package:owl/Util/util.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/ViewVariables.dart';

import '../Model/TimeSlot.dart';
import '../Model/Variables.dart';

class Controller {
  static int inputPinToAuthenticatePin(String pin) {
    String savedPin;
    if (pin != null) {
      savedPin = SharedPrefs.prefs.get("PIN");
      if (savedPin != null) {
        if (pin == savedPin) {
          return 0;
        } else {
          // 1 wrong password
          return 1;
        }
      } else {
        // 2 no password in shared Preference
        return 2;
      }
    } else {
      // 3 pin is null
      return 3;
    }
  }

  static int registerPinToSetPin(String pin) {
    if (pin != null) {
      SharedPrefs.prefs.setString("PIN", pin);
      return 0;
    } else {
      // 1 Input pin is null
      return 1;
    }
  }

  static void registerPINToSetFirstTime() {
    bool first = SharedPrefs.prefs.get("FIRST_TIME");

    if (first == null) {
      SharedPrefs.prefs.setBool("FIRST_TIME", false);
    }
  }

  static int splashScreenToIsFirstTime() {
    bool first = SharedPrefs.prefs.get("FIRST_TIME");

    if (first != null) {
      if (first == true) {
        SharedPrefs.prefs.setBool("FIRST_TIME", false);
        return 0;
      } else {
        return 1;
      }
    } else {
      return 0;
    }
  }

  static void setIntroGuideFirstTime() {
    SharedPrefs.prefs.setBool("INTRO_GUIDE_FIRST_TIME", false);
  }

  static List<List<List<String>>> getActivatedProfilesForPlugin() {
    List<List<List<String>>> profiles = [];
    for (int i = 0; i < Variables.profileList.length; i++) {
      if (Variables.profileList[i].status == 0) {
        List<String> packagesNames =
            Variables.profileList[i].getPackagesForPlugin();
        if (Variables.profileList[i].blacklist == 1) {
          // to stop owl from blocking itself in whitelist mode
          packagesNames.add("com.rit.owl");
        }
        profiles.add([
          Variables.profileList[i].days,
          Variables.profileList[i].getStartTimesForPlugin(),
          Variables.profileList[i].getEndTimesForPlugin(),
          packagesNames,
          Variables.profileList[i].getStatusForPlugin()
        ]);
      }
    }
    return profiles;
  }

  static Future<int> profileScreenToStartAppService(
      BuildContext context) async {
    if (Variables.appServiceStatus == false) {
      List<List<List<String>>> profiles =
          Controller.getActivatedProfilesForPlugin();
      if (profiles.length > 0) {
        Controller.setBlockScreenText(context);
        SharedPrefs.prefs.setInt('APP_SERVICE_STATUS', 0);
        await AppBlockRit.startAppService(profiles);
        Variables.appServiceStatus = true;
        return 0;
      } else {
        return 2;
      }
    } else {
      return 1;
    }
  }

  static Future<int> profileScreenToStopAppService() async {
    if (Variables.appServiceStatus == true) {
      SharedPrefs.prefs.setInt('APP_SERVICE_STATUS', 1);
      await AppBlockRit.stopAppService();
      Variables.appServiceStatus = false;
      return 0;
    } else {
      return 1;
    }
  }

  static int childScreenToButtonStatus() {
    return Variables.rewardStatus;
  }

  static Future<bool> getComparisonOfDay(String key) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    DocumentReference userDocument =
        FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid);
    bool returnValue = await userDocument.get().then((doc) {
      int prevDay = doc.data()[key];
      int currDay = DateTime.now().day;
      if (currDay != prevDay) {
        userDocument.set({
          key: currDay,
        }, SetOptions(merge: true));
        return true;
      } else {
        return false;
      }
    });
    return returnValue;
  }

  static void changeDayStatus(String key) {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set({
      key: DateTime.now().day,
    }, SetOptions(merge: true));
  }

  static String getHoursRewardTime(int a) {
    if ((a / 60).floor() >= 10) {
      return "${(a / 60).floor()}";
    } else {
      return "0${(a / 60).floor()}";
    }
  }

  static String getMinutesRewardTime(int a) {
    if ((a % 60) >= 10) {
      return "${a % 60}";
    } else {
      return "0${a % 60}";
    }
  }

  static String getFormatTime(int a) {
    if (a < 10) {
      return "0$a";
    } else {
      return "$a";
    }
  }

  static Future<int> childScreenToStartRewardService() async {
    if (Variables.rewardStatus == 1) {
      if (SharedPrefs.prefs.getInt('APP_SERVICE_STATUS') == 0) {
        if (Controller.parentScreenToGetMaxUsageLimit() != 0 &&
            Controller.parentScreenToGetRewardMinutes() != 0) {
          if (await getComparisonOfDay("PREV_DAY_REWARD") == true) {
            int min = smallerThan(Controller.parentScreenToGetMaxUsageLimit(),
                parentScreenToGetRewardMinutes());
            parentScreenToMinusRewardMinutes(minutes: min);
            changeDayStatus("PREV_DAY_REWARD");
            AppBlockRit.rewardTime(
                "${getHoursRewardTime(min)}:${getMinutesRewardTime(min)}:00");
          } else {
            String tempReward = await AppBlockRit.getRewardTime();
            int hours = int.parse(tempReward.split(":")[0]);
            int minutes = int.parse(tempReward.split(":")[1]);
            Controller.parentScreenToMinusRewardMinutes(
                minutes: (hours * 60) + minutes);
          }
          if (await AppBlockRit.getRewardTime() != "00:00:00") {
            setRewardsStatus(0);
            print(await AppBlockRit.startRewardService());
            return 0;
          } else {
            return 1;
          }
        } else {
          return 4;
        }
      } else {
        return 2;
      }
    } else {
      return 5;
    }
  }

  static Future<void> childScreenToEndRewardService() async {
    if (Variables.rewardStatus == 0) {
      print(await AppBlockRit.stopRewardService());
      String tempReward = await AppBlockRit.getRewardTime();
      int hours = int.parse(tempReward.split(":")[0]);
      int minutes = int.parse(tempReward.split(":")[1]);
      AppBlockRit.rewardTime(
          "${tempReward.split(":")[0]}:${tempReward.split(":")[1]}:00");
      Controller.parentScreenToAddRewardMinutes(
          minutes: (hours * 60) + minutes);
      setRewardsStatus(1);
    }
  }

  static Future<void> checkRewardStatusInit() async {
    String tempReward = await AppBlockRit.getRewardTime();
    if (tempReward == "null") {
      AppBlockRit.rewardTime("00:00:00");
    } else if (tempReward.substring(0, 5) == "00:00") {
      AppBlockRit.rewardTime("00:00:00");
      setRewardsStatus(1);
    }
  }

  static void setRewardsStatus(int value) {
    Variables.rewardStatus = value;

    var firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set({
        "REWARDS_STATUS": value,
      }, SetOptions(merge: true));
    }
  }

  static void rewardListStatusInit() async {
    if (await getComparisonOfDay("PREV_DAY_PARENT_REWARD") == true) {
      for (int i = 0; i < Variables.rewardsList.length; i++) {
        Variables.rewardsList[i].rewardStatus = 1;
        print(Variables.rewardsList[i].rewardName);
        print(Variables.rewardsList[i].id);
        Controller.parentRewardScreenToUpdateReward(Variables.rewardsList[i]);
      }
    }
  }

  static void parentScreenToRewardListInitializer(int calledFrom) {
    Variables.rewardsList.clear();
    var firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .collection('rewards')
          .orderBy("rewardName")
          .get()
          .then((allRewards) {
        allRewards.docs.forEach((singleReward) {
          Variables.rewardsList.add(Reward.fromMapObject(singleReward.data()));
          calledFrom == 0
              ? ViewVariables.childRewardsScreenRefresh()
              : ViewVariables.parentScreenRefresh();
        });
      });
    }
  }

  static Future<void> homeScreenToAddReward({Reward reward}) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('rewards');
    collectionReference.add(reward.toMap()).then((rewardAdded) {
      reward.id = rewardAdded.id;
      Variables.addReward(reward);
      // adding id to field
      collectionReference.doc(rewardAdded.id).set({
        "rewardID": rewardAdded.id,
      }, SetOptions(merge: true));

      ViewVariables.parentScreenRefresh();
    });
  }

  static void parentScreenToDeleteReward({int index, String id}) {
    Variables.deleteReward(index);

    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('rewards')
        .doc(id)
        .delete()
        .then((_) {
      print("Reward Deleted");
    });
  }

  static void parentRewardScreenToUpdateReward(Reward reward,
      {int calledFrom}) {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('rewards')
        .doc(reward.id)
        .update({
      "rewardName": reward.rewardName,
      "rewardMinutes": reward.rewardMinutes,
      "rewardStatus": reward.rewardStatus
    }).then((updatedReward) {
      if (calledFrom != null) {
        if (calledFrom == 0) {
          // 0 for Child Reward Screen
          ViewVariables.childRewardsScreenRefresh();
        }
      }
    });
  }

  static List<Reward> parentScreenToGetRewardsList() {
    return Variables.rewardsList;
  }

  static void parentScreenToAddRewardMinutes({int minutes}) {
    print("minutes added: $minutes}");
    Variables.rewardTotalMinutes = Variables.rewardTotalMinutes + minutes;

    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set({
      "REWARD_TIME": Variables.rewardTotalMinutes,
    }, SetOptions(merge: true));
  }

  static int parentScreenToMinusRewardMinutes({int minutes}) {
    if (Variables.rewardTotalMinutes >= minutes) {
      Variables.rewardTotalMinutes = Variables.rewardTotalMinutes - minutes;
      var firebaseUser = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set({
        "REWARD_TIME": Variables.rewardTotalMinutes,
      }, SetOptions(merge: true));
      return 0;
    } else {
      return 1;
    }
  }

  static void parentScreenToSetMaxUsageLimit(int maxLimit) {
    //SharedPrefs.prefs.setInt('MAX_LIMIT', maxLimit);

    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set({
      "MAX_LIMIT": maxLimit,
    }, SetOptions(merge: true));

    Variables.rewardMaxLimit = maxLimit;
  }

  static int parentScreenToGetMaxUsageLimit() {
    return Variables.rewardMaxLimit; //SharedPrefs.prefs.getInt('MAX_LIMIT');
  }

  static void settingsScreenToSetLanguage(
      String languageCode, String countryCode) {
    SharedPrefs.prefs.setString('LANGUAGE_CODE', languageCode);
    SharedPrefs.prefs.setString('COUNTRY_CODE', countryCode);
  }

  static Locale settingsScreenToGetLanguage() {
    if (SharedPrefs.prefs.getString('LANGUAGE_CODE') == null) {
      return null;
    } else {
      return Locale(SharedPrefs.prefs.getString('LANGUAGE_CODE'),
          SharedPrefs.prefs.getString('COUNTRY_CODE'));
    }
  }

  static int parentScreenToGetRewardMinutes() {
    return Variables
        .rewardTotalMinutes; //SharedPrefs.prefs.getInt('REWARD_TIME');
  }

  // to check time slot on save that it doesn't overlap
  static int addProfileScreenToTimeSlots(
      {List<TimeSlot> timeSlots, TimeSlot time}) {
    for (int i = 0; i < timeSlots.length; i++) {
      print(timeSlots[i].endTime);
      print(time.startTime);
      print("-------");
      print(time.endTime);
      print(timeSlots[i].startTime);
      if (timeSlots[i].endTime.isBefore(time.startTime) == true ||
          time.endTime.isBefore(timeSlots[i].startTime) == true) {
        print("no overlap");
      } else {
        print("overlap");
        Variables.overlapSlot = timeSlots[i];
        return 1;
      }
    }
    return 0;
  }

  static TimeSlot addProfileScreenToGetOverlapTimeSlot() {
    return Variables.overlapSlot;
  }

  static Future<void> profileScreenToProfileListInitializer() async {
    //Variables.profileList = await Variables.databaseHelper.getProfileList();

    Variables.profileList.clear();
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('profiles')
        .orderBy("profileName")
        .get()
        .then((allProfiles) {
      allProfiles.docs.forEach((singleProfile) {
        //print(result.data());
        Profile tempProfile = Profile.fromMapObject(singleProfile.data());

        DocumentReference documentReference = FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .collection('profiles')
            .doc(singleProfile.id);

        // get apps
        documentReference
            .collection('apps')
            .orderBy("appName")
            .get()
            .then((allApps) {
          allApps.docs.forEach((singleApp) {
            tempProfile.appList.add(App.fromMapObject(singleApp.data()));
          });
        });

        // get time slots
        documentReference
            .collection('timeSlots')
            .orderBy("startTime")
            .get()
            .then((allTimeSlots) {
          allTimeSlots.docs.forEach((singleTimeSlot) {
            tempProfile.timeSlots
                .add(TimeSlot.fromMapObject(singleTimeSlot.data()));
          });
        });

        Variables.profileList.add(tempProfile);
        ViewVariables.profileScreenRefresh();
      });
    });
  }

  static List<Profile> profileScreenToGetProfileList() {
    return Variables.profileList;
  }

  static Profile profileScreenToGetProfileItem(int i) {
    return Variables.profileList[i];
  }

  static Future<int> addProfileScreenToAddProfile(
      {Profile profile, bool doRefresh}) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('profiles');

    collectionReference.add(profile.toMap()).then((profileAdded) {
      profile.id = profileAdded.id;
      Variables.addProfile(index: null, profile: profile);

      // adding id to field
      collectionReference.doc(profileAdded.id).set({
        "profileID": profileAdded.id,
      }, SetOptions(merge: true));

      // add apps
      for (int c = 0; c < profile.appList.length; c++) {
        collectionReference
            .doc(profileAdded.id)
            .collection('apps')
            .add(profile.appList[c].toMap())
            .then((appAdded) {
          // adding app id
          collectionReference
              .doc(profileAdded.id)
              .collection('apps')
              .doc(appAdded.id)
              .set({
            "appID": appAdded.id,
          }, SetOptions(merge: true));
        });
      }

      // add time slots
      for (int c = 0; c < profile.timeSlots.length; c++) {
        collectionReference
            .doc(profileAdded.id)
            .collection('timeSlots')
            .add(profile.timeSlots[c].toMap())
            .then((timeSlotAdded) {
          // adding time slot id
          collectionReference
              .doc(profileAdded.id)
              .collection('timeSlots')
              .doc(timeSlotAdded.id)
              .set({
            "timSlotID": timeSlotAdded.id,
          }, SetOptions(merge: true));
        });
      }

      if (doRefresh == null || doRefresh) {
        ViewVariables.profileScreenRefresh();
      }
    });

    return 0;
  }

  static Future<int> addProfileScreenToUpdateProfile(
      {Profile profile, int index}) async {
    profileScreenToDeleteProfile(index: index, id: profile.id);
    addProfileScreenToAddProfile(profile: profile);

    // TODO: Do it the proper way

    return 0;
  }

  static void profileScreenToUnselectedDaysSelected(Profile P) {
    for (int i = 0; i < P.days.length; i++) {
      Variables.selectedDays[profileDataInputScreenToConvertDayKey(P.days[i])] =
          false;
    }
    profileDataInputScreenToSaveDayStatus();
  }

  static Future<int> profileScreenToDeleteProfile(
      {int index, String id}) async {
    Controller.profileScreenToUnselectedDaysSelected(
        Variables.profileList[index]);
    Variables.deleteProfile(index);

    var firebaseUser = FirebaseAuth.instance.currentUser;

    DocumentReference profileReference = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('profiles')
        .doc(id);

    // delete all apps
    profileReference.collection('apps').get().then((allApps) {
      allApps.docs.forEach((singleApp) {
        profileReference.collection('apps').doc(singleApp.id).delete();
      });
    });

    // delete all time slots
    profileReference.collection('timeSlots').get().then((allTimeSlots) {
      allTimeSlots.docs.forEach((singleTimeSlot) {
        profileReference
            .collection('timeSlots')
            .doc(singleTimeSlot.id)
            .delete();
      });
    });

    // delete profile
    profileReference.delete().then((_) {
      print("Profile Deleted");
    });

    return 0;
  }

  static Future<void> profileDataInputScreenToInitializeAppsList() async {
    Variables.installedAppList.clear();
    List<Application> apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: true,
        includeAppIcons: true);
    Application tmpApp;
    for (int i = 0; i < apps.length; i++) {
      tmpApp = apps[i];
      print("name: ${tmpApp.appName}, package: ${tmpApp.packageName}");
      if (tmpApp.packageName != 'com.rit.owl') {
        Variables.installedAppList.add(App(
            appName: tmpApp.appName,
            packageName: tmpApp.packageName,
            appIcon: tmpApp is ApplicationWithIcon
                ? Image.memory(tmpApp.icon)
                : null,
            appIconBytes: tmpApp is ApplicationWithIcon ? tmpApp.icon : null,
            status: 1));
      }
    }
    Variables.installedAppList.sort((app1, app2) =>
        app1.appName.toLowerCase().compareTo(app2.appName.toLowerCase()));
  }

  static List<App> appListScreenToGetAppList() {
    return Variables.installedAppList;
  }

  static App appListScreenToGetAppListAtIndex(int index) {
    return Variables.installedAppList[index];
  }

  static void appListScreenToSetAppListStatusAtIndex(int index, int status) {
    Variables.installedAppList[index].status = status;
  }

  static void appListScreenToClearStatusOfApps() {
    for (int c = 0; c < Variables.installedAppList.length; c++) {
      if (Variables.installedAppList[c].status == 0) {
        Variables.installedAppList[c].status = 1;
      }
    }
  }

  static bool profileDataInputScreenToCheckDayStatus(String key) {
    if (Variables.selectedDays[key] == false) {
      return false;
    } else {
      return true;
    }
  }

  static void setBlockScreenText(BuildContext context) {
    print(LabelsClass.blockScreenText1(context));
    AppBlockRit.blockScreenDescription(LabelsClass.blockScreenText1(context));
    AppBlockRit.blockScreenLabel(LabelsClass.blockScreenText2(context));
  }

  static void profileDataInputScreenToSetDayStatus(String key, bool status) {
    Variables.selectedDays[key] = status;
  }

  static void profileDataInputScreenToSaveDayStatus() {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set({
      "Mo": Variables.selectedDays["Mo"],
      "Tu": Variables.selectedDays["Tu"],
      "We": Variables.selectedDays["We"],
      "Th": Variables.selectedDays["Th"],
      "Fr": Variables.selectedDays["Fr"],
      "Sa": Variables.selectedDays["Sa"],
      "Su": Variables.selectedDays["Su"],
    }, SetOptions(merge: true));
    /*FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .set(Variables.selectedDays, SetOptions(merge: true));*/
  }

  static void profileDataInputScreenToGetDayStatus() {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get()
        .then((userDocument) {
      if (userDocument.data()["Mo"] != null) {
        Variables.selectedDays["Mo"] = userDocument.data()["Mo"];
      }
      if (userDocument.data()["Tu"] != null) {
        Variables.selectedDays["Tu"] = userDocument.data()["Tu"];
      }
      if (userDocument.data()["We"] != null) {
        Variables.selectedDays["We"] = userDocument.data()["We"];
      }
      if (userDocument.data()["Th"] != null) {
        Variables.selectedDays["Th"] = userDocument.data()["Th"];
      }
      if (userDocument.data()["Fr"] != null) {
        Variables.selectedDays["Fr"] = userDocument.data()["Fr"];
      }
      if (userDocument.data()["Sa"] != null) {
        Variables.selectedDays["Sa"] = userDocument.data()["Sa"];
      }
      if (userDocument.data()["Su"] != null) {
        Variables.selectedDays["Su"] = userDocument.data()["Su"];
      }
    });
  }

  static String profileDataInputScreenToConvertDayInteger(day) {
    if (day == "Mo") {
      return "2";
    } else if (day == "Tu") {
      return "3";
    } else if (day == "We") {
      return "4";
    } else if (day == "Th") {
      return "5";
    } else if (day == "Fr") {
      return "6";
    } else if (day == "Sa") {
      return "7";
    } else if (day == "Su") {
      return "1";
    } else {
      return "null";
    }
  }

  static String profileDataInputScreenToConvertDayKey(day) {
    if (day == "2") {
      return "Mo";
    } else if (day == "3") {
      return "Tu";
    } else if (day == "4") {
      return "We";
    } else if (day == "5") {
      return "Th";
    } else if (day == "6") {
      return "Fr";
    } else if (day == "7") {
      return "Sa";
    } else if (day == "1") {
      return "Su";
    } else {
      return "null";
    }
  }

  static void variablesToInitializeDatabase() {
    Variables.initializeDatabase();
  }

  static String fromIntDaysToSingleString(List<String> intDays) {
    String strDays = "";
    for (int c = 0; c < intDays.length; c++) {
      strDays += intDays[c];
    }
    return strDays;
  }

  static List<String> fromSingleStringToIntDays(String strDays) {
    List<String> intDays = [];
    for (int c = 0; c < strDays.length; c++) {
      intDays.add(strDays[c]);
    }
    return intDays;
  }

  static void initializeVariablesFromFirebase(int calledFrom) {
    // calledFrom
    // 0 for childRewardScreen
    // 1 for parentRewardScreen
    var firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      DocumentReference doc =
          FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid);
      doc.get().then((userDocument) {
        //userDocument.data()

        if (userDocument.data()["REWARD_TIME"] == null) {
          doc.set({"REWARD_TIME": 0}, SetOptions(merge: true));
          Variables.rewardTotalMinutes = 0;
        } else {
          Variables.rewardTotalMinutes = userDocument.data()["REWARD_TIME"];
        }

        if (userDocument.data()["REWARDS_STATUS"] == null) {
          doc.set({"REWARDS_STATUS": 1}, SetOptions(merge: true));
          Variables.rewardStatus = 1;
        } else {
          Variables.rewardStatus = userDocument.data()["REWARDS_STATUS"];
        }

        if (userDocument.data()["MAX_LIMIT"] == null) {
          doc.set({"MAX_LIMIT": 0}, SetOptions(merge: true));
          Variables.rewardMaxLimit = 0;
        } else {
          Variables.rewardMaxLimit = userDocument.data()["MAX_LIMIT"];
        }

        calledFrom == 0
            ? ViewVariables.childRewardsScreenRefresh()
            : ViewVariables.parentScreenRefresh();
      });
    }
  }

  static void initializeVariablesFromFirebase2() {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    DocumentReference doc =
        FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid);
    doc.get().then((userDocument) {
      if (userDocument.data()["PREV_DAY_REWARD"] == null) {
        doc.set({"PREV_DAY_REWARD": DateTime.now().day - 5},
            SetOptions(merge: true));
      }

      if (userDocument.data()["MAX_LIMIT"] == null) {
        doc.set({"PREV_DAY_PARENT_REWARD": DateTime.now().day - 5},
            SetOptions(merge: true));
      }
    });
  }

  static void setEmailForRegisteredUser(String email) {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .set({"email": email}, SetOptions(merge: true));
  }

  static void testsListInitialize(int calledFrom) {
    Variables.testsList.clear();
    var firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .collection('tests')
          .orderBy("name")
          .get()
          .then((allTests) {
        allTests.docs.forEach((singleTest) {
          Variables.testsList.add(Test.fromMapObject(singleTest.data()));
          calledFrom == 0
              ? ViewVariables.testScreenRefresh()
              : ViewVariables.childTestScreenRefresh();
        });
      });
    }
  }

  static List<Test> getTestsList() {
    return Variables.testsList;
  }

  static void addTest(Test test, {List<MCQ> newMCQs, bool doRefresh}) {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('tests');
    collectionReference.add(test.toMap()).then((testAdded) {
      test.id = testAdded.id;
      Variables.testsList.insert(0, test);
      // adding id to field
      collectionReference.doc(testAdded.id).set({
        "testID": testAdded.id,
      }, SetOptions(merge: true));

      if (newMCQs != null && newMCQs.length > 0) {
        for (int c = 0; c < newMCQs.length; c++) {
          addMCQ(testAdded.id, newMCQs[c], doRefresh: false);
        }
      }

      if (doRefresh == null || doRefresh) {
        ViewVariables.testScreenRefresh();
      }
    });
  }

  static void deleteTest(Test test, int index) {
    Variables.testsList.removeAt(index);
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('tests')
        .doc(test.id)
        .delete()
        .then((_) {
      print("Test Deleted");
    });
  }

  static void updateTest(Test test, index) {
    Variables.testsList.removeAt(index);
    Variables.testsList.insert(index, test);
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('tests')
        .doc(test.id)
        .update(test.toMap());
  }

  static void mcqListInitialize(int calledFrom, String testID) {
    Variables.mcqsList.clear();
    var firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .collection('tests')
          .doc(testID)
          .collection('mcq')
          .orderBy("question")
          .get()
          .then((allMCQs) {
        Variables.mcqsLength = allMCQs.docs.length;
        allMCQs.docs.forEach((singleMCQ) {
          Variables.mcqsList.add(MCQ.fromMapObject(singleMCQ.data()));
          calledFrom == 0
              ? ViewVariables.mcqsScreenRefresh()
              : ViewVariables.childMCQsScreenRefresh();
        });
      });
    }
  }

  static List<MCQ> getMCQsList() {
    return Variables.mcqsList;
  }

  static void addMCQ(String testID, MCQ mcq, {bool doRefresh}) {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('tests')
        .doc(testID)
        .collection('mcq');
    collectionReference.add(mcq.toMap()).then((mcqAdded) {
      mcq.id = mcqAdded.id;
      Variables.mcqsList.insert(0, mcq);
      // adding id field
      collectionReference.doc(mcqAdded.id).set({
        "mcqID": mcqAdded.id,
      }, SetOptions(merge: true));
      if (doRefresh == null || doRefresh) {
        ViewVariables.mcqsScreenRefresh();
      }
    });
  }

  static void deleteMCQ(String testID, MCQ mcq, int index) {
    Variables.mcqsList.removeAt(index);
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('tests')
        .doc(testID)
        .collection('mcq')
        .doc(mcq.id)
        .delete()
        .then((_) {
      print("MCQ Deleted");
    });
  }

  static void updateMCQ(String testID, MCQ mcq, int index) {
    Variables.mcqsList.removeAt(index);
    Variables.mcqsList.insert(index, mcq);
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('tests')
        .doc(testID)
        .collection('mcq')
        .doc(mcq.id)
        .update(mcq.toMap());
  }

  /*static Future<void> createAStandardProfile() async {
    await profileDataInputScreenToInitializeAppsList();
    List<App> apps = appListScreenToGetAppList();

    final now = new DateTime.now();
    List<TimeSlot> slots = [
      TimeSlot(
        startTime: DateTime(now.year, now.month, now.day, 0, 1, 0),
        endTime: DateTime(now.year, now.month, now.day, 23, 59, 0),
      )
    ];

    List<String> days = ['2', '3', '4', '5', '6'];
    profileDataInputScreenToSetDayStatus('Mo', true);
    profileDataInputScreenToSetDayStatus('Tu', true);
    profileDataInputScreenToSetDayStatus('We', true);
    profileDataInputScreenToSetDayStatus('Th', true);
    profileDataInputScreenToSetDayStatus('Fr', true);
    profileDataInputScreenToSaveDayStatus();

    Profile defaultProfile =
        new Profile.withInfo('Default', 1, 1, apps, slots, days);

    addProfileScreenToAddProfile(profile: defaultProfile);
  }*/

  static void checkIfFirstTimeSignUp() {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get()
        .then((doc) {
      if (!doc.exists) {
        createFirstItemsOnSignUp();
      }
    });
  }

  static void createFirstItemsOnSignUp() async {
    // Add a reward
    Reward newReward = Reward("Zimmer aufräumen", 15, 1);
    homeScreenToAddReward(reward: newReward);

    // Add a profile
    // these package names are set while assuming that the application is running on a Samsung device
    List<String> packages = [
      "com.google.android.youtube",
      "com.google.android.googlequicksearchbox",
      "com.samsung.android.calendar",
      "com.sec.android.app.voicenote",
      "com.sec.android.gallery3d",
      "com.samsung.accessibility",
      "com.sec.android.app.clockpackage",
      "com.android.chrome",
      "com.sec.android.app.myfiles",
      "com.google.android.apps.photos",
      "com.samsung.android.dialer",
      "com.sec.android.app.popupcalculator",
      "com.samsung.android.app.notes",
      "com.sec.android.app.camera"
    ];
    List<App> newApps = [];
    List<TimeSlot> newTimeSlots = [];
    List<String> newDays = ['2', '3', '4', '5', '6'];

    // Apps
    await profileDataInputScreenToInitializeAppsList();
    List<App> allApps = appListScreenToGetAppList();
    for (int c = 0; c < allApps.length; c++) {
      if (packages.contains(allApps[c].packageName)) {
        newApps.add(allApps[c]);
      }
    }

    // Time Slots
    final time = new DateTime.now();
    newTimeSlots.add(TimeSlot(
      startTime: DateTime(time.year, time.month, time.day, 0, 1, 0),
      //TimeOfDay(hour: 0 , minute: 0)
      endTime: DateTime(time.year, time.month, time.day, 23, 59, 0),
    ));

    // Days
    for (int a = 0; a < newDays.length; a++) {
      Controller.profileDataInputScreenToSetDayStatus(
          Controller.profileDataInputScreenToConvertDayKey(newDays[a]), true);
    }
    profileDataInputScreenToSaveDayStatus();

    Profile newProfile =
        Profile.withInfo("Default", 1, 1, newApps, newTimeSlots, newDays);
    addProfileScreenToAddProfile(profile: newProfile, doRefresh: false);

    // Create MCQs
    List<MCQ> newMCQs = [];
    newMCQs.add(MCQ("2 + 5 = _", "2", "5", "7", "3", "7"));
    newMCQs.add(MCQ("4 + 4 = _", "0", "8", "4", "2", "8"));
    newMCQs.add(MCQ("7 + 1 = _", "8", "6", "7", "1", "8"));
    newMCQs.add(MCQ("3 + 0 = _", "5", "4", "0", "3", "3"));
    newMCQs.add(MCQ("9 + 5 = _", "9", "12", "13", "14", "14"));

    // Add a test
    Test newTest = Test("Mathematik grundlegende Addition", 15);
    addTest(newTest, newMCQs: newMCQs, doRefresh: false);
  }

  /*static int introGuideIsFirstTime() {
    bool first = SharedPrefs.prefs.get("INTRO_GUIDE_FIRST_TIME");

    if (first != null) {
      if (first == true) {
        //SharedPrefs.prefs.setBool("INTRO_GUIDE_FIRST_TIME", false);
        return 0;
      } else {
        return 1;
      }
    } else {
      return 0;
    }
  }*/

  static bool getIntroStatus() {
    if (SharedPrefs.prefs.getBool("INTRO") == null ||
        SharedPrefs.prefs.getBool("INTRO")) {
      SharedPrefs.prefs.setBool("INTRO", false);
      return true;
    } else {
      return false;
    }
  }

  static bool getProfileIntroStatus() {
    if (SharedPrefs.prefs.getBool("PROFILE_INTRO") == null ||
        SharedPrefs.prefs.getBool("PROFILE_INTRO")) {
      SharedPrefs.prefs.setBool("PROFILE_INTRO", false);
      return true;
    } else {
      return false;
    }
  }

  static bool getAddProfileIntroStatus() {
    if (SharedPrefs.prefs.getBool("ADD_PROFILE_INTRO") == null ||
        SharedPrefs.prefs.getBool("ADD_PROFILE_INTRO")) {
      SharedPrefs.prefs.setBool("ADD_PROFILE_INTRO", false);
      return true;
    } else {
      return false;
    }
  }

  static bool getTestsIntroStatus() {
    if (SharedPrefs.prefs.getBool("TESTS_INTRO") == null ||
        SharedPrefs.prefs.getBool("TESTS_INTRO")) {
      SharedPrefs.prefs.setBool("TESTS_INTRO", false);
      return true;
    } else {
      return false;
    }
  }

  static bool getChildRewardIntroStatus() {
    if (SharedPrefs.prefs.getBool("CHILD_REWARD_INTRO") == null ||
        SharedPrefs.prefs.getBool("CHILD_REWARD_INTRO")) {
      SharedPrefs.prefs.setBool("CHILD_REWARD_INTRO", false);
      return true;
    } else {
      return false;
    }
  }

  static bool getChildTestIntroStatus() {
    if (SharedPrefs.prefs.getBool("CHILD_TEST_INTRO") == null ||
        SharedPrefs.prefs.getBool("CHILD_TEST_INTRO")) {
      SharedPrefs.prefs.setBool("CHILD_TEST_INTRO", false);
      return true;
    } else {
      return false;
    }
  }

  static void initFirebaseMessagingForNotifications() {
    /*FirebaseMessaging.instance.getToken().then((value) {
      print("token: " + value);
    });*/
    var firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      FirebaseMessaging.instance.subscribeToTopic(firebaseUser.uid);
    }
  }

  static Future<void> sendNotification(
      String subject, String title, String topic) async {
    final postUrl =
        'fcm.googleapis.com'; //'https://fcm.googleapis.com/fcm/send';
    final postUrlPart = '/fcm/send';

    String toParams = "/topics/" + topic;

    final data = {
      "notification": {"body": subject, "title": title},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "sound": 'default',
        "screen": "yourTopicName",
      },
      "to": "${toParams}"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAFS4nj1U:APA91bG0ozDTcMHKGjUVj_kOS9h41DcIT4DyqUGmXhXb4CfrvEQ6hxzvUVOTHlfx4WdM07ytKm09FW8_GRi8Mu6gywOBsXAzHSqsxyX6CwZW1NQB6BEmGS2Io-E4gv7sZKQEyC3tOvrg'
    };

    final response = await http.post(Uri.https(postUrl, postUrlPart),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do
      print("notification sent");
    } else {
      // on failure do
      print(
          "error sending notification. response code: ${response.statusCode}");
    }
  }

  static void saveEmailPassword(String email, String password) {
    SharedPrefs.prefs.setString("email", email);
    SharedPrefs.prefs.setString("password", password);
  }

  static String getEmail() {
    String email = SharedPrefs.prefs.getString("email");
    return email;
  }

  static String getPassword() {
    String password = SharedPrefs.prefs.getString("password");
    return password;
  }

  static void saveLoginType(int type, {String email, String password}) {
    // 0 for email and password
    // 1 for google
    // 2 for facebook
    SharedPrefs.prefs.setInt("loginType", type);
    if (email != null && password != null) {
      saveEmailPassword(email, password);
    }
  }

  static int getLoginType() {
    int type = SharedPrefs.prefs.getInt("loginType");
    return type;
  }
}
