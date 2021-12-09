import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/Model/Variables.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';
import 'package:owl/View/Model/ViewVariables.dart';
import 'package:owl/View/Widgets/DeleteDialog.dart';
import 'package:owl/View/Widgets/IntroGuide.dart';
import 'package:owl/View/Widgets/RewardDataInputDialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ParentRewardsScreen extends StatefulWidget {
  @override
  _ParentRewardsScreen createState() => _ParentRewardsScreen();
}

class _ParentRewardsScreen extends State<ParentRewardsScreen> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  //BannerAd bannerAd;
  //bool isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    if (Variables.rewardsList.length < 1) {
      Controller.initializeVariablesFromFirebase(1);
      Controller.parentScreenToRewardListInitializer(1);
    }
    ViewVariables.parentScreenRefresh = () {
      setState(() {});
    };

    //initBannerAd();
  }

  @override
  void dispose() {
    //bannerAd.dispose();
    super.dispose();
  }

  /*void initBannerAd() {
    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      request: AdRequest(),
      size: AdSize.banner,
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    bannerAd.load();
  }*/

  Future<dynamic> displayDeleteDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteDialog(LabelsClass.deleteRewardTask(context));
      },
    );
  }

  Widget getRewardListTiles() {
    return SmartRefresher(
      controller: refreshController,
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: () {
        Controller.initializeVariablesFromFirebase(1);
        Controller.parentScreenToRewardListInitializer(1);
        refreshController.refreshCompleted();
      },
      header: WaterDropMaterialHeader(),
      child: ListView.separated(
        padding: EdgeInsets.only(top: SizeConfig.fiveMultiplier),
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: SizeConfig.fiveMultiplier),
        itemCount: Controller.parentScreenToGetRewardsList().length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(Controller.parentScreenToGetRewardsList()[index].id),
            direction: DismissDirection.horizontal,
            background: Container(
              color: Colors.redAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(LabelsClass.delete(context),
                        style: TextStyle(
                          color: Colors.red[900],
                          fontSize: SizeConfig.twentyMultiplier,
                        )),
                  ),
                  Icon(
                    Icons.delete,
                    color: Colors.red[900],
                  ),
                ],
              ),
            ),
            secondaryBackground: Container(
              color: Colors.redAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(LabelsClass.delete(context),
                      style: TextStyle(
                        color: Colors.red[900],
                        fontSize: SizeConfig.twentyMultiplier,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.delete,
                      color: Colors.red[900],
                    ),
                  ),
                ],
              ),
            ),
            confirmDismiss: (direction) async {
              return await displayDeleteDialog();
            },
            onDismissed: (direction) {
              setState(() {
                // delete functionality
                /*Controller.parentRewardScreenToDeleteReward(rewardList[index].id);
                            rewardList.removeAt(index);
                            count--;*/

                Controller.parentScreenToDeleteReward(
                    index: index,
                    id: Controller.parentScreenToGetRewardsList()[index].id);
              });
            },
            child: Container(
              key: index == 0 ? IntroGuide.intro.keys[6] : Key(""),
              decoration: BoxDecoration(
                  color: Controller.parentScreenToGetRewardsList()[index]
                              .rewardStatus ==
                          0
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                leading: Controller.parentScreenToGetRewardsList()[index]
                            .rewardStatus ==
                        0
                    ? CircleAvatar(
                        backgroundColor: Theme.of(context).accentColor,
                        child: Icon(
                          Icons.check_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Icon(
                          Icons.card_giftcard,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                title: Text(
                  Controller.parentScreenToGetRewardsList()[index].rewardName,
                  style: Controller.parentScreenToGetRewardsList()[index]
                              .rewardStatus ==
                          0
                      ? Theme.of(context).textTheme.bodyText1
                      : Theme.of(context).textTheme.bodyText2,
                ),
                subtitle: Text(
                  "${LabelsClass.reward(context)}: ${Controller.parentScreenToGetRewardsList()[index].rewardMinutes} ${LabelsClass.minutes(context)}",
                  style: Controller.parentScreenToGetRewardsList()[index]
                              .rewardStatus ==
                          0
                      ? Theme.of(context).textTheme.headline5
                      : Theme.of(context).textTheme.headline6,
                ),
                trailing: Container(
                  child: Controller.parentScreenToGetRewardsList()[index]
                              .rewardStatus ==
                          2
                      ? Icon(
                          Icons.check_circle,
                          color: Colors.orange[300],
                        )
                      : Text(""),
                ),
                onTap: () {
                  setState(() {
                    if (Controller.parentScreenToGetRewardsList()[index]
                            .rewardStatus ==
                        0) {
                      Controller.parentScreenToGetRewardsList()[index]
                          .rewardStatus = 1;
                      Controller.parentScreenToMinusRewardMinutes(
                          minutes:
                              Controller.parentScreenToGetRewardsList()[index]
                                  .rewardMinutes);
                    } else {
                      Controller.parentScreenToGetRewardsList()[index]
                          .rewardStatus = 0;
                      Controller.parentScreenToAddRewardMinutes(
                          minutes:
                              Controller.parentScreenToGetRewardsList()[index]
                                  .rewardMinutes);
                    }
                    Controller.parentRewardScreenToUpdateReward(
                        Controller.parentScreenToGetRewardsList()[index]);
                  });
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return RewardDataInputDialog(
                        oldReward:
                            Controller.parentScreenToGetRewardsList()[index],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          SizedBox(
            height: SizeConfig.tenMultiplier,
          ),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  TimeOfDay hoursSelected = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: 0, minute: 0),
                    builder: (BuildContext context, Widget child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child,
                      );
                    },
                    helpText: LabelsClass.setMaxUsageTime(context),
                  );
                  setMaxUsageTime(hoursSelected);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).buttonColor),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).accentColor),
                ),
                child: Text(
                  LabelsClass.maxUsageLimit(context),
                  style: TextStyle(
                    fontSize: SizeConfig.fifteenMultiplier,
                  ),
                ),
              ),
              Text(
                maxUsageLimit.toString() + " " + LabelsClass.minutes(context),
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.tenMultiplier,
          ),*/
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                LabelsClass.totalRewards(context) + ": ",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                Controller.parentScreenToGetRewardMinutes().toString() +
                    " " +
                    LabelsClass.minutes(context),
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.tenMultiplier,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.twentyMultiplier),
                    topRight: Radius.circular(SizeConfig.twentyMultiplier)),
              ),
              child: Stack(
                children: [
                  getRewardListTiles(),
                  /*Container(
                    child: isBannerAdReady
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: bannerAd.size.width.toDouble(),
                              height: bannerAd.size.height.toDouble(),
                              child: AdWidget(ad: bannerAd),
                            ),
                          )
                        : Text(""),
                  ),*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
