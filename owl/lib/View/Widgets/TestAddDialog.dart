import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/Model/Test.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';

class TestAddDialog extends StatefulWidget {
  Test oldTest;

  TestAddDialog({this.oldTest});

  @override
  _TestAddDialogState createState() => _TestAddDialogState();
}

class _TestAddDialogState extends State<TestAddDialog> {
  String name;
  int rewardMinutes;
  final formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    if (widget.oldTest != null) {
      name = widget.oldTest.name;
      rewardMinutes = widget.oldTest.rewardMinutes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(SizeConfig.twentyMultiplier),
        ),
      ),
      // Logically and for UI consistency, if the below "title" is used then also add a title to other dialogs e.g. add reward dialog
      /*title: Center(
        child: Text(
          LabelsClass.addTest(context),
          style: TextStyle(
            fontSize: SizeConfig.eighteenMultiplier,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),*/
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LabelsClass.title(context),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            TextFormField(
              textAlign: TextAlign.center,
              initialValue: widget.oldTest != null ? widget.oldTest.name : '',
              keyboardType: TextInputType.text,
              maxLines: 1,
              onChanged: (value) {
                name = value;
              },
              style: Theme.of(context).textTheme.bodyText2,
              validator: (value) {
                if (value.isEmpty) {
                  return LabelsClass.titleIsRequired(context);
                }
                return null;
              },
              decoration: InputDecoration(
                  errorStyle: TextStyle(
                fontSize: SizeConfig.twelveMultiplier,
              )),
            ),
            SizedBox(
              height: SizeConfig.twentyMultiplier,
            ),
            Text(
              LabelsClass.rewardMinutes(context),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            TextFormField(
              textAlign: TextAlign.center,
              initialValue: widget.oldTest != null
                  ? widget.oldTest.rewardMinutes.toString()
                  : '',
              keyboardType: TextInputType.number,
              maxLines: 1,
              onChanged: (value) {
                rewardMinutes = int.parse(value.trim());
              },
              style: Theme.of(context).textTheme.bodyText2,
              validator: (value) {
                if (value.isEmpty) {
                  return LabelsClass.rewardMinutesAreRequired(context);
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
            Navigator.of(context).pop(null);
          },
        ),
        TextButton(
          child: Text(
            LabelsClass.save(context),
          ),
          onPressed: () {
            if (formKey.currentState.validate()) {
              Test tempTest = Test(name, rewardMinutes);
              Navigator.of(context).pop(tempTest);
            }
          },
        ),
      ],
    );
  }
}
