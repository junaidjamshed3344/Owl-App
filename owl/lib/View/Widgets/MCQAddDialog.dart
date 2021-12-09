import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/Model/MCQ.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';

class MCQAddDialog extends StatefulWidget {
  MCQ oldMCQ;

  MCQAddDialog({this.oldMCQ});

  @override
  _MCQAddDialogState createState() => _MCQAddDialogState();
}

class _MCQAddDialogState extends State<MCQAddDialog> {
  String question;
  String option1;
  String option2;
  String option3;
  String option4;
  final formKey = GlobalKey<FormState>();
  String correctOption = "A";

  void initState() {
    super.initState();
    if (widget.oldMCQ != null) {
      correctOption = setValueForCorrectOption();
      question = widget.oldMCQ.question;
      option1 = widget.oldMCQ.option1;
      option2 = widget.oldMCQ.option2;
      option3 = widget.oldMCQ.option3;
      option4 = widget.oldMCQ.option4;
    }
  }

  String setValueForCorrectOption() {
    if (widget.oldMCQ.correctOption == widget.oldMCQ.option1) {
      return "A";
    } else if (widget.oldMCQ.correctOption == widget.oldMCQ.option2) {
      return "B";
    } else if (widget.oldMCQ.correctOption == widget.oldMCQ.option3) {
      return "C";
    } else {
      return "D";
    }
  }

  String getCorrectOption() {
    if (correctOption == "A") {
      return option1;
    } else if (correctOption == "B") {
      return option2;
    } else if (correctOption == "C") {
      return option3;
    } else if (correctOption == "D") {
      return option4;
    } else {
      return "null";
    }
  }

  Widget getDropDown() {
    return DropdownButton(
      value: correctOption,
      items: [
        DropdownMenuItem(
          value: "A",
          child: Text(
            "A",
            maxLines: 1,
          ),
        ),
        DropdownMenuItem(
          value: "B",
          child: Text(
            "B",
            maxLines: 1,
          ),
        ),
        DropdownMenuItem(
          value: "C",
          child: Text(
            "C",
            maxLines: 1,
          ),
        ),
        DropdownMenuItem(
          value: "D",
          child: Text(
            "D",
            maxLines: 1,
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          correctOption = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.twentyMultiplier))),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LabelsClass.addANewMCQ(context),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Divider(
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  height: SizeConfig.twentyMultiplier,
                ),
                Text(
                  LabelsClass.question(context),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  initialValue:
                      widget.oldMCQ != null ? widget.oldMCQ.question : '',
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  onChanged: (value) {
                    question = value;
                  },
                  style: Theme.of(context).textTheme.bodyText2,
                  validator: (value) {
                    if (value.isEmpty) {
                      return LabelsClass.questionIsRequired(context);
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
                  LabelsClass.optionA(context),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  initialValue:
                      widget.oldMCQ != null ? widget.oldMCQ.option1 : '',
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  onChanged: (value) {
                    option1 = value;
                  },
                  style: Theme.of(context).textTheme.bodyText2,
                  validator: (value) {
                    if (value.isEmpty) {
                      return LabelsClass.allOptionsAreRequired(context);
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
                  LabelsClass.optionB(context),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  initialValue:
                      widget.oldMCQ != null ? widget.oldMCQ.option2 : '',
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  onChanged: (value) {
                    option2 = value;
                  },
                  style: Theme.of(context).textTheme.bodyText2,
                  validator: (value) {
                    if (value.isEmpty) {
                      return LabelsClass.allOptionsAreRequired(context);
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
                  LabelsClass.optionC(context),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  initialValue:
                      widget.oldMCQ != null ? widget.oldMCQ.option3 : '',
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  onChanged: (value) {
                    option3 = value;
                  },
                  style: Theme.of(context).textTheme.bodyText2,
                  validator: (value) {
                    if (value.isEmpty) {
                      return LabelsClass.allOptionsAreRequired(context);
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
                  LabelsClass.optionD(context),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  initialValue:
                      widget.oldMCQ != null ? widget.oldMCQ.option4 : '',
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  onChanged: (value) {
                    option4 = value;
                  },
                  style: Theme.of(context).textTheme.bodyText2,
                  validator: (value) {
                    if (value.isEmpty) {
                      return LabelsClass.allOptionsAreRequired(context);
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
                ListTile(
                  title: Text(
                    LabelsClass.correctOption(context),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: getDropDown(),
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
                  MCQ tempMCQ = MCQ(question, option1, option2, option3,
                      option4, getCorrectOption());
                  Navigator.of(context).pop(tempMCQ);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
