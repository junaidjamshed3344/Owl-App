import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';

class TestExitWarningDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(SizeConfig.twentyMultiplier))),
      content: Text(
        "${LabelsClass.sureExitTest2(context)}\n${LabelsClass.sureExitTest1(context)}",
        style: Theme.of(context).textTheme.bodyText2,
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
        TextButton(
          child: Text(
            LabelsClass.exit(context),
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
