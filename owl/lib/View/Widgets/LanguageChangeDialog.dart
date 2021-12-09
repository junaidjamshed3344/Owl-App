import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/LabelsClass.dart';
import '../Model/Language.dart';
import '../Model/SizeConfig.dart';

class LanguageChangeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(SizeConfig.twentyMultiplier))),
      title: Text(
        LabelsClass.changeLanguage(context),
        style: Theme.of(context).textTheme.bodyText2,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Image.asset(
                'images/american_flag.png',
                height: SizeConfig.thirtyMultiplier,
              ),
              TextButton(
                onPressed: () {
                  Language.changeLanguage(context, "en", "US");
                  Navigator.of(context).pop();
                },
                child: Text(
                  LabelsClass.english(context),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Image.asset(
                'images/german_flag.png',
                height: SizeConfig.thirtyMultiplier,
              ),
              TextButton(
                onPressed: () {
                  Language.changeLanguage(context, "de", "DE");
                  Navigator.of(context).pop();
                },
                child: Text(
                  LabelsClass.german(context),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
