import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/Model/Profile.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';

class BlackListModeDialog extends StatelessWidget {
  Profile profile;

  BlackListModeDialog(this.profile);

  Widget getHeightSizeBox(double height) {
    return SizedBox(
      height: height,
    );
  }

  Widget getCircleAvatar(context, outerColor, iconColor) {
    return CircleAvatar(
      backgroundColor: outerColor,
      child: Icon(
        Icons.add,
        color: iconColor,
        size: SizeConfig.twentyMultiplier,
      ),
    );
  }

  Decoration getBoxDecoration(double radius, context) {
    return BoxDecoration(
      color: Theme.of(context).accentColor,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 0.5,
          blurRadius: 6,
          offset: Offset(3, 6),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LabelsClass.selectBlockingMode(context),
            style: TextStyle(
              fontSize: SizeConfig.twentyMultiplier,
            ),
          ),
          getHeightSizeBox(SizeConfig.thirtyMultiplier),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                LabelsClass.blacklistApps(context),
              ),
              GestureDetector(
                onTap: () {
                  profile.blacklist = 0; // true
                  Navigator.of(context).pop(true);
                  // set mode to blacklist
                  // open select apps screen
                },
                child: Container(
                  height: SizeConfig.fortyMultiplier,
                  child: getCircleAvatar(context, Colors.black, Colors.white),
                  decoration:
                      getBoxDecoration(SizeConfig.fiftyMultiplier, context),
                ),
              ),
            ],
          ),
          getHeightSizeBox(SizeConfig.twentyMultiplier),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                LabelsClass.whitelistApps(context),
              ),
              GestureDetector(
                onTap: () {
                  // set mode to whitelist
                  // open select apps screen
                  profile.blacklist = 1; // false
                  Navigator.of(context).pop(true);
                },
                child: Container(
                  height: SizeConfig.fortyMultiplier,
                  child: getCircleAvatar(context, Colors.grey, Colors.white),
                  decoration:
                      getBoxDecoration(SizeConfig.fiftyMultiplier, context),
                ),
              ),
            ],
          ),
          getHeightSizeBox(SizeConfig.thirtyMultiplier),
          Text(
            LabelsClass.blockingModeMessage1(context) +
                "\n" +
                LabelsClass.blockingModeMessage2(context),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: SizeConfig.twelveMultiplier,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            LabelsClass.cancel(context),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}
