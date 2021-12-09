import 'package:owl/Controller/Controller.dart';

import 'App.dart';
import 'TimeSlot.dart';

class Profile {
  String id;
  String name;
  int blacklist;
  int status;
  List<App> appList;
  List<TimeSlot> timeSlots;
  List<String> days;

  Profile() {
    name = '';
    blacklist = 1; //false
    status = 1; //false
    appList = [];
    timeSlots = [];
    days = [];
  }

  Profile.withInfo(this.name, this.blacklist, this.status, this.appList,
      this.timeSlots, this.days);

  bool isComplete() {
    if (name.length > 0 &&
        appList.isNotEmpty &&
        timeSlots.isNotEmpty &&
        days.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void printProfile() {
    if (id != null) {
      print('id: $id');
    }
    print('name: $name');
    print('blacklist: $blacklist');
    print('status: $status');
    /*print('appList: $appList');
    print('timeSlots: $timeSlots');*/

    for (int c = 0; c < appList.length; c++) {
      print('app: ' + appList[c].appName);
    }

    for (int c = 0; c < timeSlots.length; c++) {
      print('time slot: ' +
          timeSlots[c].startTime.toIso8601String() +
          ' - ' +
          timeSlots[c].endTime.toIso8601String());
    }

    print('days: $days');
  }

  List<String> getStartTimesForPlugin() {
    List<String> startTimes = [];
    for (int i = 0; i < timeSlots.length; i++) {
      startTimes.add(timeSlots[i].getFormatStartTimeForPlugin());
    }
    return startTimes;
  }

  List<String> getEndTimesForPlugin() {
    List<String> endTimes = [];
    for (int i = 0; i < timeSlots.length; i++) {
      endTimes.add(timeSlots[i].getFormatEndTimeForPlugin());
    }
    return endTimes;
  }

  List<String> getPackagesForPlugin() {
    List<String> packages = [];
    for (int i = 0; i < appList.length; i++) {
      packages.add(appList[i].packageName);
    }
    return packages;
  }

  List<String> getStatusForPlugin() {
    List<String> status = [];
    if (blacklist == 1) {
      status.add("false");
    } else {
      status.add("true");
    }
    return status;
  }

  // Convert a Profile object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['profileID'] = id;
    }
    map['profileName'] = name;
    map['profileIsBlacklist'] = blacklist;
    map['profileIsActive'] = status;
    map['profileDays'] = Controller.fromIntDaysToSingleString(days);

    return map;
  }

  // Extract a Profile object from a Map object
  Profile.fromMapObject(Map<String, dynamic> map) {
    this.id = map['profileID'];
    this.name = map['profileName'];
    this.blacklist = map['profileIsBlacklist'];
    this.status = map['profileIsActive'];
    this.days = Controller.fromSingleStringToIntDays(map['profileDays']);
    this.appList = [];
    this.timeSlots = [];
  }

  void copyProfile(Profile profile) {
    this.id = profile.id;
    this.name = profile.name;
    this.blacklist = profile.blacklist;
    this.status = profile.status;
    this.appList.addAll(profile.appList);
    this.timeSlots.addAll(profile.timeSlots);
    this.days.addAll(profile.days);
  }
}
