import 'package:owl/Model/App.dart';
import 'package:owl/Model/Profile.dart';
import 'package:owl/Model/Reward.dart';
import 'package:owl/Model/Test.dart';
import 'package:owl/Model/TimeSlot.dart';

import '../Util/DatabaseHelper.dart';
import 'MCQ.dart';

class Variables {
  static List<Reward> rewardsList = [];
  static List<Profile> profileList = [];
  static List<App> installedAppList = [];
  static List<MCQ> mcqsList = [];
  static int mcqsLength = 0;
  static List<Test> testsList = [];
  static var selectedDays = {
    'Mo': false,
    'Tu': false,
    'We': false,
    'Th': false,
    'Fr': false,
    'Sa': false,
    'Su': false
  };
  static DatabaseHelper databaseHelper;
  static bool appServiceStatus = false;
  static TimeSlot overlapSlot;
  static int rewardMaxLimit = 0;
  static int rewardTotalMinutes = 0;
  static int rewardStatus = 1;

  static void initializeDatabase() {
    databaseHelper = DatabaseHelper();
  }

  static int addReward(Reward reward) {
    try {
      //rewardsList.add(reward);
      rewardsList.insert(0, reward);
      return 0;
    } on Exception catch (e) {
      print(e);
      return 1;
    }
  }

  static int deleteReward(int index) {
    try {
      rewardsList.removeAt(index);
      return 0;
    } on Exception catch (e) {
      print(e);
      return 1;
    }
  }

  static int addProfile({int index, Profile profile}) {
    try {
      if (index == null)
        profileList.add(profile);
      else
        profileList.insert(index, profile);
      return 0;
    } on Exception catch (e) {
      print(e);
      return 1;
    }
  }

  static int deleteProfile(int index) {
    try {
      profileList.removeAt(index);
      return 0;
    } on Exception catch (e) {
      print(e);
      return 1;
    }
  }
}
