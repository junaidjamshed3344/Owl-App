import 'dart:async';
import 'dart:io';

import 'package:owl/Model/App.dart';
import 'package:owl/Model/Reward.dart';
import 'package:owl/Model/TimeSlot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/Profile.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String rewardTable = 'reward_table';
  String colId = 'id';
  String colRewardName = 'rewardName';
  String colRewardMinutes = 'rewardMinutes';
  String colRewardStatus = 'rewardStatus';

  String profileTable = 'profile_table';
  String colProfileId = 'id';
  String colProfileName = 'profileName';
  String colProfileMode = 'profileMode';
  String colProfileStatus = 'profileStatus';
  String colProfileDays = 'profileDays';

  String timeSlotsTable = 'time_slots_table';
  String colTimeSlotId = 'profileID';
  String colStartTime = 'startTime';
  String colEndTime = 'endTime';

  String appTable = 'app_table';
  String colAppId = 'profileID';
  String colAppName = 'appName';
  String colPackageName = 'packageName';
  String colAppIcon = 'appIcon';
  String colAppStatus = 'status';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'owlByRIT.db';

    var owlDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return owlDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $rewardTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colRewardName TEXT, '
        '$colRewardMinutes INTEGER, $colRewardStatus INTEGER)');

    await db.execute(
        'CREATE TABLE $profileTable($colProfileId INTEGER PRIMARY KEY AUTOINCREMENT, $colProfileName TEXT, '
        '$colProfileMode INTEGER, $colProfileStatus INTEGER, $colProfileDays TEXT)');

    await db.execute(
        'CREATE TABLE $timeSlotsTable($colTimeSlotId INTEGER, $colStartTime TEXT, '
        '$colEndTime TEXT)');

    await db
        .execute('CREATE TABLE $appTable($colAppId INTEGER, $colAppName TEXT, '
            '$colPackageName TEXT, $colAppIcon TEXT, $colAppStatus INTEGER)');
  }

  /* ------------------------------------------------------------------------ */
  /* ------------------------------------------------------------------------ */
  /* ----------------------------- Reward Table ----------------------------- */
  /* ------------------------------------------------------------------------ */
  /* ------------------------------------------------------------------------ */

  // Fetch Operation: Get all reward objects from database
  Future<List<Map<String, dynamic>>> getRewardMapList() async {
    Database db = await this.database;

    var result =
        await db.rawQuery('SELECT * FROM $rewardTable order by $colId ASC');
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Reward List' [ List<Reward> ]
  Future<List<Reward>> getRewardList() async {
    var rewardMapList = await getRewardMapList();
    int count = rewardMapList.length;

    List<Reward> rewardList = [];

    for (int c = 0; c < count; c++) {
      rewardList.add(Reward.fromMapObject(rewardMapList[c]));
    }

    return rewardList;
  }

  // Insert Operation: Insert a Reward object to database
  Future<int> insertReward(Reward reward) async {
    Database db = await this.database;
    var result = await db.insert(rewardTable, reward.toMap());
    return result;
  }

  // Update Operation: Update a Reward object and save it to database
  Future<int> updateReward(Reward reward) async {
    var db = await this.database;
    var result = await db.update(rewardTable, reward.toMap(),
        where: '$colId = ?', whereArgs: [reward.id]);
    return result;
  }

  // Delete Operation: Delete a Reward object from database
  Future<int> deleteReward(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $rewardTable WHERE $colId = $id');
    return result;
  }

  // Get number of Reward objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $rewardTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  /* ------------------------------------------------------------------------ */
  /* ------------------------------------------------------------------------ */
  /* ---------------------------- Profile Table ----------------------------- */
  /* ------------------------------------------------------------------------ */
  /* ------------------------------------------------------------------------ */

  // Fetch Operation: Get all profile objects from database
  Future<List<Map<String, dynamic>>> getProfileMapList() async {
    Database db = await this.database;

    var result = await db
        .rawQuery('SELECT * FROM $profileTable order by $colProfileId ASC');
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Profile List' [ List<Profile> ]
  Future<List<Profile>> getProfileList() async {
    var profileMapList = await getProfileMapList();
    int count = profileMapList.length;

    List<Profile> profileList = [];

    for (int c = 0; c < count; c++) {
      profileList.add(Profile.fromMapObject(profileMapList[c]));
    }

    // add Time slots and Apps for each profile
    for (int c = 0; c < count; c++) {
      profileList[c].timeSlots = await getSpecificTimeSlotList(profileList[c].id);
      profileList[c].appList = await getSpecificTAppList(profileList[c].id);
    }

    return profileList;
  }

  // Insert Operation: Insert a Profile object to database
  Future<int> insertProfile(Profile profile) async {
    print('printing profile in DB');
    profile.printProfile();

    Database db = await this.database;
    var result = await db.insert(profileTable, profile.toMap());

    // insert time slots and apps for this profile
    for (int c = 0; c < profile.timeSlots.length; c++) {
      profile.timeSlots[c].id = result.toString();
      await insertTimeSlot(profile.timeSlots[c]);
    }

    for (int c = 0; c < profile.appList.length; c++) {
      profile.appList[c].id = result.toString();
      await insertApp(profile.appList[c]);
    }

    return result;
  }

  // Update Operation: Update a Profile object and save it to database
  Future<int> updateProfile(Profile profile) async {
    var db = await this.database;
    var result = await db.update(profileTable, profile.toMap(),
        where: '$colProfileId = ?', whereArgs: [profile.id]);

    // delete previous time slots and apps
    await deleteTimeSlot(profile.id);
    await deleteApp(profile.id);

    //insert new time slots and apps
    for (int c = 0; c < profile.timeSlots.length; c++) {
      profile.timeSlots[c].id = profile.id;
      await insertTimeSlot(profile.timeSlots[c]);
    }

    for (int c = 0; c < profile.appList.length; c++) {
      profile.appList[c].id = profile.id;
      await insertApp(profile.appList[c]);
    }

    return result;
  }

  // Delete Operation: Delete a Profile object from database
  Future<int> deleteProfile(String id) async {
    var db = await this.database;
    int result = await db
        .rawDelete('DELETE FROM $profileTable WHERE $colProfileId = $id');

    // delete all time slots and apps for this profile
    await deleteTimeSlot(id);
    await deleteApp(id);

    return result;
  }

  // Get number of Profile objects in database
  Future<int> getProfilesCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $profileTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

/* ------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------ */
/* --------------------------- Time Slots Table --------------------------- */
/* ------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------ */

// Fetch Operation: Get all TimeSlot objects from database
  Future<List<Map<String, dynamic>>> getTimeSlotMapList() async {
    Database db = await this.database;

    var result = await db
        .rawQuery('SELECT * FROM $timeSlotsTable order by $colTimeSlotId ASC');
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'TimeSlot List' [ List<TimeSlot> ]
  Future<List<TimeSlot>> getTimeSlotList() async {
    var timeSlotMapList = await getTimeSlotMapList();
    int count = timeSlotMapList.length;

    List<TimeSlot> timeSlotList = [];

    for (int c = 0; c < count; c++) {
      timeSlotList.add(TimeSlot.fromMapObject(timeSlotMapList[c]));
    }

    return timeSlotList;
  }

  // Get only the specific time slots
  Future<List<TimeSlot>> getSpecificTimeSlotList(String id) async {
    var timeSlotMapList = await getTimeSlotMapList();
    int count = timeSlotMapList.length;

    List<TimeSlot> timeSlotList = [];

    for (int c = 0; c < count; c++) {
      if (TimeSlot.fromMapObject(timeSlotMapList[c]).id == id) {
        timeSlotList.add(TimeSlot.fromMapObject(timeSlotMapList[c]));
      }
    }

    return timeSlotList;
  }

  // Insert Operation: Insert a TimeSlot object to database
  Future<int> insertTimeSlot(TimeSlot timeSlot) async {
    Database db = await this.database;
    var result = await db.insert(timeSlotsTable, timeSlot.toMap());

    return result;
  }

  // Update Operation: Update a TimeSlot object and save it to database
  Future<int> updateTimeSlot(TimeSlot timeSlot) async {
    var db = await this.database;
    var result = await db.update(timeSlotsTable, timeSlot.toMap(),
        where: '$colTimeSlotId = ?', whereArgs: [timeSlot.id]);

    return result;
  }

  // Delete Operation: Delete a TimeSlot object from database
  Future<int> deleteTimeSlot(String id) async {
    var db = await this.database;
    int result = await db
        .rawDelete('DELETE FROM $timeSlotsTable WHERE $colTimeSlotId = $id');

    return result;
  }

/* ------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------ */
/* ------------------------------ Apps Table ------------------------------ */
/* ------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------ */

// Fetch Operation: Get all App objects from database
  Future<List<Map<String, dynamic>>> getAppMapList() async {
    Database db = await this.database;

    var result =
        await db.rawQuery('SELECT * FROM $appTable order by $colAppId ASC');
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'App List' [ List<App> ]
  Future<List<App>> getAppList() async {
    var appMapList = await getAppMapList();
    int count = appMapList.length;

    List<App> appList = [];

    for (int c = 0; c < count; c++) {
      appList.add(App.fromMapObject(appMapList[c]));
    }

    return appList;
  }

  // Get only the specific apps
  Future<List<App>> getSpecificTAppList(String id) async {
    var appMapList = await getAppMapList();
    int count = appMapList.length;

    List<App> appList = [];

    for (int c = 0; c < count; c++) {
      if (App.fromMapObject(appMapList[c]).id == id) {
        appList.add(App.fromMapObject(appMapList[c]));
      }
    }

    return appList;
  }

  // Insert Operation: Insert a App object to database
  Future<int> insertApp(App app) async {
    Database db = await this.database;
    var result = await db.insert(appTable, app.toMap());

    return result;
  }

  // Update Operation: Update a App object and save it to database
  Future<int> updateApp(App app) async {
    var db = await this.database;
    var result = await db.update(appTable, app.toMap(),
        where: '$colAppId = ?', whereArgs: [app.id]);

    return result;
  }

  // Delete Operation: Delete a TimeSlot object from database
  Future<int> deleteApp(String id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $appTable WHERE $colAppId = $id');

    return result;
  }
}
