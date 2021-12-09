import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class App {
  String id;
  String appName;
  String packageName;
  Image appIcon;
  int status;
  Uint8List appIconBytes;

  App(
      {this.appName,
      this.packageName,
      this.appIcon,
      this.status,
      this.appIconBytes});

  // Convert a App object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['appID'] = id;
    }
    map['appName'] = appName;
    map['appPackageName'] = packageName;
    map['appIcon'] = base64.encode(appIconBytes);
    map['appStatus'] = status;

    return map;
  }

  // Extract a App object from a Map object
  App.fromMapObject(Map<String, dynamic> map) {
    this.id = map['appID'];
    this.appName = map['appName'];
    this.packageName = map['appPackageName'];
    this.appIcon = Image.memory(base64.decode(map['appIcon']));
    this.appIconBytes = base64.decode(map['appIcon']);
    this.status = map['appStatus'];
  }

  bool compare(App app) {
    if (this.packageName == app.packageName && this.appName == app.appName) {
      return true;
    } else {
      return false;
    }
  }
}
