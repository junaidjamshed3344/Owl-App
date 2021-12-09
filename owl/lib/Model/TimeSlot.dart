class TimeSlot {
  String id;
  DateTime startTime;
  DateTime endTime;

  TimeSlot({this.startTime, this.endTime});

  String getFormatStartTimeForPlugin() {
    if (startTime.hour < 10) {
      if (startTime.minute < 10) {
        return "0${startTime.hour}:0${startTime.minute}:00";
      } else {
        return "0${startTime.hour}:${startTime.minute}:00";
      }
    } else {
      if (startTime.minute < 10) {
        return "${startTime.hour}:0${startTime.minute}:00";
      } else {
        return "${startTime.hour}:${startTime.minute}:00";
      }
    }
  }

  String getFormatEndTimeForPlugin() {
    if (endTime.hour < 10) {
      if (endTime.minute < 10) {
        return "0${endTime.hour}:0${endTime.minute}:00";
      } else {
        return "0${endTime.hour}:${endTime.minute}:00";
      }
    } else {
      if (endTime.minute < 10) {
        return "${endTime.hour}:0${endTime.minute}:00";
      } else {
        return "${endTime.hour}:${endTime.minute}:00";
      }
    }
  }

  // Convert a TimeSlot object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['timSlotID'] = id;
    }
    map['startTime'] =
        startTime.toIso8601String(); // convert to string before saving
    map['endTime'] = endTime.toIso8601String();

    return map;
  }

  // Extract a TimeSlot object from a Map object
  TimeSlot.fromMapObject(Map<String, dynamic> map) {
    this.id = map['timSlotID'];
    this.startTime = DateTime.parse(
        map['startTime']); // convert to DateTime after retrieving
    this.endTime = DateTime.parse(map['endTime']);
  }
}

/*
String dateTime = new DateTime.now().toIso8601String();
print(dateTime);
DateTime date= DateTime.parse(dateTime);
print(date);*/
