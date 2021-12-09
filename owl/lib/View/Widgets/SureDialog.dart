import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/View/Model/SizeConfig.dart';

import '../Model/LabelsClass.dart';

class SureDialog extends StatelessWidget {
  String title;

  SureDialog(this.title);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(SizeConfig.twentyMultiplier))),
      content: Text(
        title,
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
