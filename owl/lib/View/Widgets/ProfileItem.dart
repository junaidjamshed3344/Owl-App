import 'package:app_block_rit/app_block_rit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/Model/Profile.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';
import 'package:owl/View/Screens/ProfileDataInputScreen.dart';
import 'package:owl/View/Widgets/ErrorDialog.dart';
import 'package:owl/View/Widgets/IntroGuide.dart';

class ProfileItem extends StatefulWidget {
  Profile profile;
  int index;

  ProfileItem(this.profile, this.index) {
    profile.printProfile();
  }

  @override
  _ProfileItem createState() => _ProfileItem();
}

class _ProfileItem extends State<ProfileItem> {
  @override
  void initState() {
    super.initState();
  }

  Widget getHeightSizeBox(double height) {
    return SizedBox(
      height: height,
    );
  }

  String getTranslatedDay(String day) {
    if (day == 'Mo') {
      return LabelsClass.monday(context);
    } else if (day == 'Tu') {
      return LabelsClass.tuesday(context);
    } else if (day == 'We') {
      return LabelsClass.wednesday(context);
    } else if (day == 'Th') {
      return LabelsClass.thursday(context);
    } else if (day == 'Fr') {
      return LabelsClass.friday(context);
    } else if (day == 'Sa') {
      return LabelsClass.saturday(context);
    } else if (day == 'Su') {
      return LabelsClass.sunday(context);
    } else {
      return '-';
    }
  }

  Widget getDayCircleAvatar(day) {
    return CircleAvatar(
      radius: SizeConfig.widthEighteenMultiplier,
      backgroundColor: widget.profile.blacklist == 0
          ? Theme.of(context).accentColor
          : Theme.of(context).primaryColor,
      child: Text(
        getTranslatedDay(Controller.profileDataInputScreenToConvertDayKey(day)),
        style: widget.profile.blacklist == 0
            ? Theme.of(context).textTheme.headline6
            : Theme.of(context).textTheme.headline5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: widget.index == 0 ? IntroGuide.profileIntro.keys[0] : Key(""),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext) =>
                ProfileDataInputScreen(widget.profile, widget.index),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.profile.blacklist == 0
              ? Theme.of(context).primaryColor
              : Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(SizeConfig.tenMultiplier),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.5,
              blurRadius: 6,
              offset: Offset(3, 6),
            )
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Text(
                widget.profile.name,
                style: widget.profile.blacklist == 0
                    ? Theme.of(context).textTheme.headline3
                    : Theme.of(context).textTheme.headline4,
              ),
              trailing: Container(
                key: widget.index == 0 ? IntroGuide.profileIntro.keys[2] : Key(""),
                width: SizeConfig.oneFiftyMultiplier,
                child: ListView.separated(
                  itemCount: widget.profile.days.length,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (BuildContext context, int index) =>
                      VerticalDivider(
                    width: 3,
                    color: widget.profile.blacklist == 0
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).accentColor,
                  ),
                  itemBuilder: (context, index) {
                    return getDayCircleAvatar(widget.profile.days[index]);
                  },
                  shrinkWrap: true,
                ),
              ),
            ),
            getHeightSizeBox(SizeConfig.tenMultiplier),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                key: widget.index == 0 ? IntroGuide.profileIntro.keys[1] : Key(""),
                height: SizeConfig.fortyMultiplier,
                child: ListView.separated(
                  itemCount: widget.profile.appList.length,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (BuildContext context, int index) =>
                      VerticalDivider(
                    width: 3,
                    color: widget.profile.blacklist == 0
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).accentColor,
                  ),
                  itemBuilder: (context, index) {
                    return CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      child: widget.profile.appList[index].appIcon,
                    );
                  },
                ),
              ),
            ),
            getHeightSizeBox(SizeConfig.tenMultiplier),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                key: widget.index == 0 ? IntroGuide.profileIntro.keys[3] : Key(""),
                style: ButtonStyle(
                  backgroundColor: widget.profile.status == 1
                      ? MaterialStateProperty.all<Color>(Colors.green[300])
                      : MaterialStateProperty.all<Color>(Colors.red[300]),
                ),
                child: widget.profile.status == 1
                    ? Text(LabelsClass.activate(context),
                        //////////////////////////////////////////change here theme///////////////////////
                        //////////////////////////////////////////change here theme///////////////////////
                        //////////////////////////////////////////change here theme///////////////////////
                        //////////////////////////////////////////change here theme///////////////////////
                        style: TextStyle(color: Colors.white))
                    : Text(LabelsClass.deactivate(context),
                        //////////////////////////////////////////change here theme///////////////////////
                        //////////////////////////////////////////change here theme///////////////////////
                        //////////////////////////////////////////change here theme///////////////////////
                        //////////////////////////////////////////change here theme///////////////////////
                        style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  if (await AppBlockRit.usagePermissionStatus() == true &&
                      await AppBlockRit.floatingWindowStatus() == true) {
                    if (widget.profile.status == 1) {
                      setState(() {
                        widget.profile.status = 0; //true
                      });

                      print(await Controller.profileScreenToStopAppService());
                      print(await Controller.profileScreenToStartAppService(
                          context));
                    } else {
                      setState(() {
                        widget.profile.status = 1; //false
                      });
                      print(await Controller.profileScreenToStopAppService());
                      print(await Controller.profileScreenToStartAppService(
                          context));
                    }
                    await Controller.addProfileScreenToUpdateProfile(
                        profile: widget.profile, index: widget.index);
                  } else {
                    return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog();
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
