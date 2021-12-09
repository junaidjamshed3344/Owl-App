import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/Model/Test.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';
import 'package:owl/View/Model/ViewVariables.dart';
import 'package:owl/View/Widgets/TestExitWarningDialog.dart';

class ChildMCQsScreen extends StatefulWidget {
  Test test;

  ChildMCQsScreen(this.test);

  @override
  _ChildMCQsScreenState createState() => _ChildMCQsScreenState();
}

class _ChildMCQsScreenState extends State<ChildMCQsScreen> {
  List<String> answers = [];

  void initState() {
    super.initState();
    Controller.mcqListInitialize(1, widget.test.id);
    ViewVariables.childMCQsScreenRefresh = () {
      setState(() {
        answers.add(
            Controller.getMCQsList()[Controller.getMCQsList().length - 1]
                .option1);
      });
    };
    //answers = List.filled(Variables.mcqsLength, "", growable: true);
  }

  Widget getAnswerParts(String text, int index) {
    return ListTile(
      leading: Radio(
        value: text,
        groupValue: answers[index],
        onChanged: (value) {
          setState(() {
            answers[index] = value;
          });
        },
      ),
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  Widget getQuestionParts(String leading, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(SizeConfig.fiveMultiplier),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Theme.of(context).primaryColor),
          child: Text(
            leading,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                text,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getMCQsListView() {
    return FirebaseAuth.instance.currentUser == null
        ? Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(LabelsClass.noTestIsActive(context)),
                ],
              )
            ],
          )
        : ListView.builder(
          itemCount: Controller.getMCQsList().length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.all(SizeConfig.fiveMultiplier),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius:
                    BorderRadius.circular(SizeConfig.tenMultiplier),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0.5,
                    blurRadius: 6,
                    offset: Offset(3, 6),
                  )
                ],
              ),
              padding: EdgeInsets.all(SizeConfig.tenMultiplier),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getQuestionParts("${index + 1}",
                      Controller.getMCQsList()[index].question),
                  Divider(
                    color: Theme.of(context).primaryColor,
                  ),
                  getAnswerParts(
                      Controller.getMCQsList()[index].option1, index),
                  getAnswerParts(
                      Controller.getMCQsList()[index].option2, index),
                  getAnswerParts(
                      Controller.getMCQsList()[index].option3, index),
                  getAnswerParts(
                      Controller.getMCQsList()[index].option4, index),
                ],
              ),
            ),
          ),
        );
  }

  Future<bool> showTestExitWarningDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return TestExitWarningDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showTestExitWarningDialog(),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          title: Text(widget.test.name,
              style: Theme.of(context).textTheme.headline1),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.twentyMultiplier),
                topRight: Radius.circular(SizeConfig.twentyMultiplier)),
          ),
          child: getMCQsListView(),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.check),
          label: Text("Done"),
          backgroundColor: Colors.green[300],
          onPressed: () {
            int correct = 0;
            for (int c = 0; c < answers.length; c++) {
              if (answers[c] == Controller.getMCQsList()[c].correctOption) {
                correct++;
              }
            }
            String message =
                "${LabelsClass.marks(context)}: $correct / ${answers.length}";
            if (correct == answers.length) {
              message += ". ${LabelsClass.rewardsAdded(context)}.";
              setState(() {
                Controller.parentScreenToAddRewardMinutes(
                    minutes: widget.test.rewardMinutes);
              });
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                message,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              duration: Duration(seconds: 3),
              backgroundColor: Theme.of(context).primaryColor,
            ));
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
