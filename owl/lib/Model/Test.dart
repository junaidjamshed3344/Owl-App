class Test {
  String id;
  String name;
  int rewardMinutes;
  bool isActive = false;

  Test(this.name, this.rewardMinutes);

  // Convert a test object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['testID'] = id;
    }
    map['name'] = name;
    map['rewardMinutes'] = rewardMinutes;
    map['isActive'] = isActive;

    return map;
  }

  // Extract a test object from a Map object
  Test.fromMapObject(Map<String, dynamic> map) {
    this.id = map['testID'];
    this.name = map['name'];
    this.rewardMinutes = map['rewardMinutes'];
    this.isActive = map['isActive'];
  }
}
