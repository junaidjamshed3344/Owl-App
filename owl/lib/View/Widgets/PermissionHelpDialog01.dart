import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/View/Model/SizeConfig.dart';

import '../Model/LabelsClass.dart';

class PermissionHelpDialog01 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(SizeConfig.twentyMultiplier))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LabelsClass.readAppUsagePermission(context),
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: SizeConfig.twentyFiveMultiplier,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              LabelsClass.step1(context),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          SizedBox(
            height: SizeConfig.tenMultiplier,
          ),
          Image.asset(
            'images/permission_help01.png',
            fit: BoxFit.contain,
            height: SizeConfig.sixtyMultiplier,
          ),
          SizedBox(
            height: SizeConfig.tenMultiplier,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              LabelsClass.step2(context),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          SizedBox(
            height: SizeConfig.tenMultiplier,
          ),
          Image.asset(
            'images/permission_help02.png',
            fit: BoxFit.contain,
            height: SizeConfig.oneTwentyFiveMultiplier,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            LabelsClass.ok(context),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}
