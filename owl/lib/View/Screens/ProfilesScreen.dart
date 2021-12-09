import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/Model/Variables.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';
import 'package:owl/View/Model/ViewVariables.dart';
import 'package:owl/View/Widgets/DeleteDialog.dart';
import 'package:owl/View/Widgets/IntroGuide.dart';
import 'package:owl/View/Widgets/ProfileItem.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProfilesScreen extends StatefulWidget {
  @override
  _ProfilesScreen createState() => _ProfilesScreen();
}

class _ProfilesScreen extends State<ProfilesScreen> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    if (Variables.profileList.length < 1) {
      Controller.profileScreenToProfileListInitializer();
    }
    ViewVariables.profileScreenRefresh = () {
      setState(() {});
    };
    Future.delayed(const Duration(seconds: 1), () {
      checkIntroGuide();
      setState(() {});
    });
  }

  void checkIntroGuide() {
    if (Controller.getProfileIntroStatus()) {
      IntroGuide.profileIntro.start(context);
    }
  }

  Future<dynamic> displayDeleteDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteDialog(LabelsClass.deleteProfile(context));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.twentyMultiplier),
                    topRight: Radius.circular(SizeConfig.twentyMultiplier)),
              ),
              child: Container(
                padding: EdgeInsets.all(SizeConfig.tenMultiplier),
                child: SmartRefresher(
                  controller: refreshController,
                  enablePullDown: true,
                  enablePullUp: false,
                  onRefresh: () {
                    Controller.profileScreenToProfileListInitializer();
                    Future.delayed(const Duration(seconds: 1), () {
                      setState(() {});
                    });
                    refreshController.refreshCompleted();
                  },
                  header: WaterDropMaterialHeader(),
                  child: ListView.separated(
                    itemCount:
                        Controller.profileScreenToGetProfileList().length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(
                            Controller.profileScreenToGetProfileList()[index]
                                .id
                                .toString()),
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
                        onDismissed: (direction) async {
                          await Controller.profileScreenToDeleteProfile(
                              index: index,
                              id: Controller.profileScreenToGetProfileItem(
                                      index)
                                  .id);
                          setState(() {
                            // delete functionality
                          });
                        },
                        child: ProfileItem(
                            Controller.profileScreenToGetProfileItem(index),
                            index),
                      );
                    },
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(height: SizeConfig.tenMultiplier),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
