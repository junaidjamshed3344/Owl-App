import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:owl/View/Model/ViewVariables.dart';

import '../../Controller/Controller.dart';
import '../../Model/Reward.dart';
import '../Model/LabelsClass.dart';
import '../Model/SizeConfig.dart';

class RewardDataInputDialog extends StatefulWidget {
  Reward oldReward;

  RewardDataInputDialog({this.oldReward});

  @override
  _RewardDataInputDialogState createState() => _RewardDataInputDialogState();
}

class _RewardDataInputDialogState extends State<RewardDataInputDialog> {
  String rewardName = "Reward Name";
  int rewardMinutes = 10;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(SizeConfig.twentyMultiplier))),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LabelsClass.enterRewardTitle(context),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            TextFormField(
              textAlign: TextAlign.center,
              initialValue:
                  widget.oldReward != null ? widget.oldReward.rewardName : '',
              keyboardType: TextInputType.text,
              maxLines: 1,
              onChanged: (value) {
                rewardName = value;
              },
              style: Theme.of(context).textTheme.bodyText2,
              validator: (value) {
                if (value.isEmpty) {
                  return LabelsClass.rewardNameError01(context);
                } else if (value.length > 20) {
                  return LabelsClass.maxInput20(context);
                }
                return null;
              },
              decoration: InputDecoration(
                  errorStyle: TextStyle(
                fontSize: SizeConfig.twelveMultiplier,
              )),
            ),
            SizedBox(
              height: SizeConfig.fortyMultiplier,
            ),
            Text(
              LabelsClass.enterRewardMinutes(context),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            TextFormField(
              textAlign: TextAlign.center,
              initialValue: widget.oldReward != null
                  ? widget.oldReward.rewardMinutes.toString()
                  : '',
              keyboardType: TextInputType.number,
              maxLines: 1,
              onChanged: (value) {
                rewardMinutes = int.parse(value);
              },
              style: Theme.of(context).textTheme.bodyText2,
              /*inputFormatters: [
                LengthLimitingTextInputFormatter(3),
              ],*/
              validator: (value) {
                if (value.isEmpty) {
                  return LabelsClass.rewardMinutesError01(context);
                }
                if (value.length > 3) {
                  return LabelsClass.maxInput999(context);
                }
                return null;
              },
              decoration: InputDecoration(
                  errorStyle: TextStyle(
                fontSize: SizeConfig.twelveMultiplier,
              )),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            LabelsClass.cancel(context),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            LabelsClass.ok(context),
          ),
          onPressed: () async {
            if (formKey.currentState.validate()) {
              if (widget.oldReward == null) {
                Reward tmp = new Reward(rewardName, rewardMinutes, 1);
                //Controller.parentRewardScreenToInsertReward(tmp);
                await Controller.homeScreenToAddReward(reward: tmp);
              } else {
                if (rewardName != "Reward Name") {
                  widget.oldReward.rewardName = rewardName;
                }
                if (rewardMinutes != 10) {
                  widget.oldReward.rewardMinutes = rewardMinutes;
                }
                Controller.parentRewardScreenToUpdateReward(widget.oldReward);
              }
              setState(() {});
              ViewVariables.parentScreenRefresh.call();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
