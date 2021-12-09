import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/Model/App.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/ViewVariables.dart';

class AppListScreen extends StatefulWidget {
  List<App> tempAppList=[];
  List<App> finalAppList;
  bool loader = true;

  AppListScreen(this.finalAppList);

  @override
  _AppListScreenState createState() => _AppListScreenState();
}

class _AppListScreenState extends State<AppListScreen> {
  void populateList() {
    widget.tempAppList.addAll(widget.finalAppList);
    for (int i = 0; i < Controller.appListScreenToGetAppList().length; i++) {
      for (int j = 0; j < widget.tempAppList.length; j++) {
        if (Controller.appListScreenToGetAppListAtIndex(i).packageName ==
            widget.tempAppList[j].packageName) {
          Controller.appListScreenToGetAppListAtIndex(i).status = 0;
          break;
        }
      }
    }
  }

  @override
  void initState() {
    // set all previously selected apps
    //loading();
    super.initState();
    if (Controller.appListScreenToGetAppList().length <= 0) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => timerFunction());
    } else {
      widget.loader = false;
      populateList();
    }

  }

  Future<bool> _willPopScope() async{
    Controller.appListScreenToClearStatusOfApps();
    return true;
  }

  void timerFunction(){
    Timer(Duration(seconds: 3), () {
      if (Controller.appListScreenToGetAppList().length > 0) {
        setState(() {
          widget.loader = false;
          populateList();
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _willPopScope(),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Controller.appListScreenToClearStatusOfApps();
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            LabelsClass.appList(context),
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        body: Container(
          child: widget.loader
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                )
              : ListView.builder(
                  itemCount: Controller.appListScreenToGetAppList().length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0), //only(bottom: 10.0),
                      child: Container(
                        child: ListTile(
                          selected:
                              Controller.appListScreenToGetAppListAtIndex(index)
                                          .status ==
                                      0
                                  ? true
                                  : false,
                          onTap: () {
                            setState(() {
                              if (Controller.appListScreenToGetAppListAtIndex(index).status == 1) {
                                Controller.appListScreenToGetAppListAtIndex(index).status = 0;
                                widget.tempAppList.add(Controller.appListScreenToGetAppListAtIndex(index));
                              } else if (Controller.appListScreenToGetAppListAtIndex(index).status == 0) {
                                Controller.appListScreenToGetAppList()[index].status = 1;
                                for (int i = 0; i < widget.tempAppList.length; i++) {
                                  if (Controller.appListScreenToGetAppListAtIndex(index).packageName == widget.tempAppList[i].packageName) {
                                    widget.tempAppList.removeAt(i);
                                    break;
                                  }
                                }
                                //widget.tempAppList.remove(Controller.appListScreenToGetAppListAtIndex(index));
                              }
                              ViewVariables.profileDataInputScreenRefresh.call();
                            });
                          },
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).accentColor,
                            child:
                                Controller.appListScreenToGetAppListAtIndex(index)
                                    .appIcon,
                          ),
                          title: Text(
                            Controller.appListScreenToGetAppListAtIndex(index)
                                .appName,
                            style:
                                Controller.appListScreenToGetAppListAtIndex(index)
                                            .status ==
                                        0
                                    ? Theme.of(context).textTheme.bodyText1
                                    : Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                        decoration: BoxDecoration(
                            color:
                                Controller.appListScreenToGetAppListAtIndex(index)
                                            .status ==
                                        0
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).accentColor,
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                      ),
                    );
                  },
                ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).buttonColor,
          child: Icon(Icons.check_rounded),
          onPressed: () {
            // implement save here
            widget.finalAppList.clear();
            widget.finalAppList.addAll(widget.tempAppList);
            Controller.appListScreenToClearStatusOfApps();
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
