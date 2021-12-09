
import 'package:app_block_rit/app_block_rit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';
import 'package:owl/View/Widgets/PermissionHelpDialog01.dart';
import 'package:owl/View/Widgets/PermissionHelpDialog02.dart';

import 'RegisterPIN.dart';

class PermissionScreen extends StatefulWidget {
  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {

  @override
  Widget build(BuildContext context) {
    //changeOpacity();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'images/blinking.gif',
              fit: BoxFit.contain,
              height: SizeConfig.fortyMultiplier,
            ),
            Container(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.symmetric(vertical: SizeConfig.tenMultiplier),
              child: Center(
                child: Text(
                  LabelsClass.permissions(context),
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ),
            Image.asset(
              'images/owl_hidden.png',
              fit: BoxFit.contain,
              height: SizeConfig.fortyMultiplier,
            ),
          ],
        ),
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius:
                          BorderRadius.circular(SizeConfig.tenMultiplier),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0.5,
                          blurRadius: 7,
                          offset: Offset(0, 0),
                        )
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        LabelsClass.readAppUsagePermission(context),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      trailing: InkWell(
                        child: Icon(
                          Icons.info_outline_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PermissionHelpDialog01();
                            },
                          );
                        },
                      ),
                      /*subtitle: Text(
                        "The permission is needed after android 7 in order to run owl app",
                        style: Theme.of(context).textTheme.headline6,
                      ),*/
                      onTap: () async {
                        await AppBlockRit.readAppUsagePermission();
                      },
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.twentyFiveMultiplier,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius:
                          BorderRadius.circular(SizeConfig.tenMultiplier),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0.5,
                          blurRadius: 7,
                          offset: Offset(0, 0),
                        )
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        LabelsClass.floatingWindowPermission(context),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      trailing: InkWell(
                        child: Icon(
                          Icons.info_outline_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PermissionHelpDialog02();
                            },
                          );
                        },
                      ),
                      /*subtitle: Text(
                        "The permission is needed after android 10 in order to run owl app",
                        style: Theme.of(context).textTheme.headline6,
                      ),*/
                      onTap: () async {
                        if (await AppBlockRit.floatingWindowPermission() == "SDK version smaller than Pie"){
                          final snackBar = SnackBar(
                            content: Text(
                                "You don't require  this permission"
                            ),
                            duration: Duration(milliseconds: 1000),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.twentyMultiplier,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: MaterialButton(
                      onPressed: () async {
                        if (await AppBlockRit.usagePermissionStatus() == true &&
                            await AppBlockRit.floatingWindowStatus() == true) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPIN(0),
                              ));
                        } else {
                          final snackBar = SnackBar(
                            content: Text(
                              LabelsClass.bothPermissionsRequired(context),
                            ),
                            duration: Duration(milliseconds: 1000),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Text(
                        LabelsClass.next(context),
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
