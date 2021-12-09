import 'package:app_block_rit_example/ChildScreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:app_block_rit/app_block_rit.dart';
import 'package:usage_stats/usage_stats.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  List<EventUsageInfo> events;
  Map<String, UsageInfo> queryE;
  DateTime startdate;
  DateTime enddate;
  DateTime rewardtime;
  String reward="00:00:00";
  String timespent="00:00:00";
  List<String> packagenames=["com.whatsapp","com.facebook.katana"];
  int totaltime1=0;
  int totaltime2=0;
  bool submitted=false;
  @override

  Future<void> initState(){
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      AppBlockRit.setAppPackageName("com.example.app_block_rit_example");
      print("Starting App");

    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<int> initUsage(DateTime startDate,DateTime endDate) async {
    UsageStats.grantUsagePermission();
    Map<String, UsageInfo> queryAndAggregateUsageStats = await  UsageStats.queryAndAggregateUsageStats(startDate, endDate);
    setState(() {
      this.queryE=queryAndAggregateUsageStats;
    });
    print(queryE);
    return bonusTimeUsage();
  }
  
  int bonusTimeUsage(){
    int time=0;
    print("bonus time");
    for(int i=0;i<packagenames.length;i++){
      if (this.queryE[packagenames[i]]!=null){
        print (int.parse(this.queryE[packagenames[i]].totalTimeInForeground));
        time+=int.parse(this.queryE[packagenames[i]].totalTimeInForeground);
      }
    }
    return time;
  }

  String getduration(int timestamp){
    Duration duration = new Duration(days: 0, hours: 0, minutes: 0, seconds: 0, milliseconds: timestamp);
    String sDuration="${duration.inHours}:${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))}";
    return sDuration;
  }

  Future<void> stopAppService() async {
    String msgx= await AppBlockRit.stopAppService();
    print(msgx);
  }

  Future<void> startAppService() async {
    List<List<List<String>>> temp = List.generate(2, (i) => List.generate(5, (j) => List<String>(2)),growable: false);

    temp[0][0]= ["3","4"];
    temp[0][1]= ["12:30:00","13:30:00","14:30:00","15:30:00"];
    temp[0][2]=["13:29:00","14:29:00","15:29:00","16:29:00"];
    temp[0][3]=["com.facebook.katana","com.whatsapp"];
    temp[0][4]=["true"];

    temp[1][0]=["1","2","5"];
    temp[1][1]= ["12:04:00","13:59:00"];
    temp[1][2]=["13:59:00","14:59:00"];
    temp[1][3]=["com.whatsapp","com.facebook.katana"];
    temp[1][4]=["false"];
    print(temp);

    String msgx = await AppBlockRit.startAppService(temp);
    print(msgx);
  }

  Future<void> setrewardtime() async {
    print(reward);
    String msgx= await AppBlockRit.rewardTime(reward);
    print(msgx);
  }

  Future<void> usagesettings() async {
    String msgx=await AppBlockRit.readAppUsagePermission();
    print(msgx);
    msgx=await AppBlockRit.floatingWindowPermission();
    print(msgx);
  }

  Future<void> start_reward_service() async {

    String msgx=await AppBlockRit.startRewardService();
    print(msgx);
  }

  Future<void> stop_reward_service() async {
    String msgx=await AppBlockRit.stopRewardService();
    print(msgx);
  }



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          height: 800,
          width: 400,
          child: Column(
            children: [
              Center(
                child: Text('Put bonus Minutes (1-60)'),
              ),
              TextField(
                onSubmitted: (value){
                  submitted=true;
                  reward="00:"+value+":00";
                  setrewardtime();
                },),
              MaterialButton(child: Icon(Icons.settings),onPressed: (){usagesettings();},),
              MaterialButton(
                child: Text("Activate1"),
                onPressed: (){
                  startAppService();
                },
              ),
              MaterialButton(
                child: Text("Deactivate1"),
                onPressed: (){
                  stopAppService();
                },
              ),
              MaterialButton(
                child: Text("Start Bonus Time"),
                onPressed: () async {
                  await start_reward_service();
                },
              ),
              MaterialButton(
                child: Text("Stop Bonus Time"),
                onPressed:  () async {
                  await stop_reward_service();
                },
              ),
              Text("Total time spent: " + timespent),
              Text("Reward Time Remaining: " + reward),
            ],
          ),),
      ),
    );
  }
}
