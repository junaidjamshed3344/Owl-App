import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/Model/MCQ.dart';
import 'package:owl/Model/Test.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';
import 'package:owl/View/Model/ViewVariables.dart';
import 'package:owl/View/Widgets/DeleteDialog.dart';
import 'package:owl/View/Widgets/MCQAddDialog.dart';

class MCQsScreen extends StatefulWidget {
  Test test;

  MCQsScreen(this.test);

  @override
  _MCQsScreenState createState() => _MCQsScreenState();
}

class _MCQsScreenState extends State<MCQsScreen> {
  void initState() {
    super.initState();
    Controller.mcqListInitialize(0, widget.test.id);
    ViewVariables.mcqsScreenRefresh = () {
      setState(() {});
    };
  }

  Future<dynamic> displayDeleteDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteDialog(LabelsClass.sureDeleteMCQ(context));
      },
    );
  }

  Widget getQuestionParts(String leading, String text, bool isQuestion) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isQuestion
            ? Container(
                padding: EdgeInsets.all(SizeConfig.fiveMultiplier),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor),
                child: Text(
                  leading,
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Text(leading),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(text),
            ],
          ),
        ),
      ],
    );
  }

  Widget getMCQsListView() {
    return ListView.builder(
      itemCount: Controller.getMCQsList().length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.all(SizeConfig.fiveMultiplier),
        child: Dismissible(
          key: Key(Controller.getMCQsList()[index].id),
          direction: DismissDirection.horizontal,
          background: Container(
            color: Colors.redAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(LabelsClass.delete(context),
                      style: TextStyle(
                        color: Colors.red[900],
                        fontSize: SizeConfig.twentyMultiplier,
                      )),
                ),
                Icon(
                  Icons.delete,
                  color: Colors.red[900],
                ),
              ],
            ),
          ),
          secondaryBackground: Container(
            color: Colors.redAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(LabelsClass.delete(context),
                    style: TextStyle(
                      color: Colors.red[900],
                      fontSize: SizeConfig.twentyMultiplier,
                    )),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.delete,
                    color: Colors.red[900],
                  ),
                ),
              ],
            ),
          ),
          confirmDismiss: (direction) async {
            return await displayDeleteDialog();
          },
          onDismissed: (direction) {
            setState(() {
              Controller.deleteMCQ(
                  widget.test.id, Controller.getMCQsList()[index], index);
            });
          },
          child: GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(SizeConfig.tenMultiplier),
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
                      Controller.getMCQsList()[index].question, true),
                  Divider(
                    color: Theme.of(context).primaryColor,
                  ),
                  getQuestionParts(
                      "A) ", Controller.getMCQsList()[index].option1, false),
                  getQuestionParts(
                      "B) ", Controller.getMCQsList()[index].option2, false),
                  getQuestionParts(
                      "C) ", Controller.getMCQsList()[index].option3, false),
                  getQuestionParts(
                      "D) ", Controller.getMCQsList()[index].option4, false),
                ],
              ),
            ),
            onLongPress: () async {
              MCQ tempMCQ = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MCQAddDialog(oldMCQ: Controller.getMCQsList()[index]);
                },
              );
              if (tempMCQ != null) {
                tempMCQ.id = Controller.getMCQsList()[index].id;
                setState(() {
                  Controller.updateMCQ(widget.test.id, tempMCQ, index);
                });
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomInset: false,
      body: Scaffold(
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).buttonColor,
          child: Icon(Icons.add),
          onPressed: () async {
            MCQ tempMCQ = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return MCQAddDialog();
              },
            );
            if (tempMCQ != null) {
              setState(() {
                Controller.addMCQ(widget.test.id, tempMCQ);
              });
            }
          },
        ),
      ),
    );
  }
}
