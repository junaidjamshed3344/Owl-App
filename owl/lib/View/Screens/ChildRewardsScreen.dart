import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/Model/Variables.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';
import 'package:owl/View/Model/ViewVariables.dart';
import 'package:owl/View/Widgets/IntroGuide.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChildRewardsScreen extends StatefulWidget {
  @override
  _ChildRewardsScreenState createState() => _ChildRewardsScreenState();
}

class _ChildRewardsScreenState extends State<ChildRewardsScreen> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  //BannerAd bannerAd;
  //bool isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    if (Variables.rewardsList.length < 1) {
      Controller.initializeVariablesFromFirebase(0);
      Controller.parentScreenToRewardListInitializer(0);
    }
    ViewVariables.childRewardsScreenRefresh = () {
      setState(() {});
    };
    Future.delayed(const Duration(seconds: 1), () {
      checkIntroGuide();
    });

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

  void checkIntroGuide() {
    if (Controller.getChildRewardIntroStatus()) {
      IntroGuide.childRewardIntro.start(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Builder(
        builder: (context) => Column(
          children: [
            getHeightSizeBox(),
            Row(
              key: IntroGuide.childRewardIntro.keys[0],
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LabelsClass.maxUsageLimit(context) + ": ",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  Controller.parentScreenToGetMaxUsageLimit().toString() +
                      " " +
                      LabelsClass.minutes(context),
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
            getHeightSizeBox(),
            Row(
              key: IntroGuide.childRewardIntro.keys[1],
              mainAxisSize: MainAxisSize.min,
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
            getHeightSizeBox(),
            ElevatedButton(
              key: IntroGuide.childRewardIntro.keys[2],
              onPressed: () async {
                //add Reward status in shared pref
                if (Controller.childScreenToButtonStatus() == 1) {
                  int result =
                      await Controller.childScreenToStartRewardService();
                  if (result == 2) {
                    final snackBar = SnackBar(
                      content: Text(
                        LabelsClass.blockingServiceDeactivated(context),
                      ),
                      duration: Duration(milliseconds: 1000),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (result == 1 || result == 4) {
                    final snackBar = SnackBar(
                      content: Text(
                        LabelsClass.noRewardMinutes(context),
                      ),
                      duration: Duration(milliseconds: 1000),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  setState(() {});
                } else {
                  await Controller.childScreenToEndRewardService();
                  setState(() {});
                }
              },
              style: ButtonStyle(
                backgroundColor: Controller.childScreenToButtonStatus() == 1
                    ? MaterialStateProperty.all<Color>(Colors.green[300])
                    : MaterialStateProperty.all<Color>(Colors.red[300]),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Text(
                LabelsClass.useRewards(context),
              ),
            ),
            getHeightSizeBox(),
            Expanded(
              child: Container(
                key: IntroGuide.childRewardIntro.keys[3],
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(SizeConfig.twentyMultiplier),
                    topLeft: Radius.circular(SizeConfig.twentyMultiplier),
                  ),
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
      ),
    );
  }

  Color getBackgroundColor(int index) {
    int status = Controller.parentScreenToGetRewardsList()[index].rewardStatus;
    if (status == 0) {
      return Theme.of(context).primaryColor;
    } else {
      return Theme.of(context).accentColor;
    }
  }

  Widget getRewardListTiles() {
    /*List<Reward> tempRewardList = new List<Reward>();
    for (int i = 0; i < Variables.rewardsList.length; i++) {
      if (Variables.rewardsList[i].rewardStatus == true) {
        tempRewardList.add(Variables.rewardsList[i]);
      }
    }*/
    return FirebaseAuth.instance.currentUser == null
        ? Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(LabelsClass.signInToSeeRewards(context)),
                ],
              )
            ],
          )
        : SmartRefresher(
            controller: refreshController,
            enablePullDown: true,
            enablePullUp: false,
            onRefresh: () {
              Controller.initializeVariablesFromFirebase(0);
              Controller.parentScreenToRewardListInitializer(0);
              refreshController.refreshCompleted();
            },
            header: WaterDropMaterialHeader(),
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(height: SizeConfig.fiveMultiplier),
              itemCount: Controller.parentScreenToGetRewardsList().length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: getBackgroundColor(index),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: ListTile(
                      title: Text(
                        Controller.parentScreenToGetRewardsList()[index]
                            .rewardName,
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
                                0
                            ? Text("")
                            : ElevatedButton(
                                child: Text(
                                    Controller.parentScreenToGetRewardsList()[
                                                    index]
                                                .rewardStatus ==
                                            1
                                        ? "Complete"
                                        : "Pending"),
                                style: ButtonStyle(
                                  backgroundColor:
                                      Controller.parentScreenToGetRewardsList()[
                                                      index]
                                                  .rewardStatus ==
                                              1
                                          ? MaterialStateProperty.all<Color>(
                                              Colors.green[300])
                                          : MaterialStateProperty.all<Color>(
                                              Colors.orange[300]),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                ),
                                onPressed: () {
                                  int status = Controller
                                          .parentScreenToGetRewardsList()[index]
                                      .rewardStatus;
                                  if (status == 1) {
                                    Controller.parentScreenToGetRewardsList()[
                                            index]
                                        .rewardStatus = 2;
                                    Controller.sendNotification(
                                        LabelsClass.childWaiting(context),
                                        LabelsClass.approveTask(context),
                                        FirebaseAuth.instance.currentUser.uid);
                                  } else if (status == 2) {
                                    Controller.parentScreenToGetRewardsList()[
                                            index]
                                        .rewardStatus = 1;
                                  }
                                  Controller.parentRewardScreenToUpdateReward(
                                      Controller.parentScreenToGetRewardsList()[
                                          index],
                                      calledFrom: 0);
                                },
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget getHeightSizeBox() {
    return SizedBox(
      height: SizeConfig.twentyMultiplier,
    );
  }

  Widget getWidthSizeBox() {
    return SizedBox(
      width: SizeConfig.twentyMultiplier,
    );
  }
}
