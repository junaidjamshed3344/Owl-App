import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/View/Model/SizeConfig.dart';

import '../Model/LabelsClass.dart';

class SignOutDialog extends StatelessWidget {
  String name;

  SignOutDialog(this.name);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(SizeConfig.twentyMultiplier))),
      content: Text(
        (name != null && name.length > 0)
            ? "${LabelsClass.signOutFrom(context)} $name?"
            : LabelsClass.sureSignOut(context),
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
            LabelsClass.signOut(context),
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
