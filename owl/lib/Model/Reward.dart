class Reward {
  String id;
  String rewardName;
  int rewardMinutes;
  int rewardStatus; // 0 enabled, 1 disabled, 2 pending

  Reward(this.rewardName, this.rewardMinutes, this.rewardStatus);

  // Convert a Reward object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['rewardID'] = id;
    }
    map['rewardName'] = rewardName;
    map['rewardMinutes'] = rewardMinutes;
    map['rewardStatus'] = rewardStatus;

    return map;
  }

  // Extract a Reward object from a Map object
  Reward.fromMapObject(Map<String, dynamic> map) {
    this.id = map['rewardID'];
    this.rewardName = map['rewardName'];
    this.rewardMinutes = map['rewardMinutes'];
    this.rewardStatus = map['rewardStatus'];
  }
}
