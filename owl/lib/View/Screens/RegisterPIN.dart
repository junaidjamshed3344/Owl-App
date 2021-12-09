import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/View/Model/AuthenticationWrapper.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';

class RegisterPIN extends StatefulWidget {
  int fromPage;

  RegisterPIN(this.fromPage);

  @override
  _RegisterPIN createState() => _RegisterPIN();
}

class _RegisterPIN extends State<RegisterPIN> {
  String pin = "";
  String finalPIN = "";
  bool isFirstTime = true;
  String pinMessage;

  @override
  void initState() {
    sleep(Duration(milliseconds: 500));
    super.initState();
  }

  Widget getWidthSizeBox(double height) {
    return SizedBox(
      width: height,
    );
  }

  void checkPIN() {
    if (pin.length == 6) {
      if (isFirstTime) {
        finalPIN = pin;
        isFirstTime = false;
        setState(() {
          pin = "";
          pinMessage = LabelsClass.confirmPIN(context);
          print("pinMessage: $pinMessage");
        });
      } else {
        if (finalPIN == pin) {
          Controller.registerPinToSetPin(pin);
          Controller.registerPINToSetFirstTime();
          if (widget.fromPage == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AuthenticationWrapper(),
              ),
            );
          } else if (widget.fromPage == 1) {
            Navigator.pop(context);
          }
        } else {
          finalPIN = "";
          isFirstTime = true;
          setState(() {
            pin = "";
            pinMessage = LabelsClass.pinNotMatch(context);
            print("pinMessage: $pinMessage");
          });
        }
      }
    }
  }

  Widget pinCircleAvatar(int pinLengthLimit) {
    return CircleAvatar(
      child: pin.length <= pinLengthLimit
          ? CircleAvatar(
              radius: SizeConfig.fifteenMultiplier,
              backgroundColor: Colors.white,
            )
          : Text(
              pin[pinLengthLimit],
              style: TextStyle(fontSize: SizeConfig.twentyMultiplier),
            ),
      radius: SizeConfig.twentyMultiplier,
    );
  }

  Widget keypadButton(String value) {
    return GestureDetector(
      child: CircleAvatar(
        child: Text(
          value,
          style: TextStyle(fontSize: SizeConfig.thirtyFiveMultiplier),
        ),
        radius: SizeConfig.fortyMultiplier,
      ),
      onTap: () {
        setState(() {
          pin += value;
          checkPIN();
        });
      },
    );
  }

  Widget build(BuildContext context) {
    if (pinMessage == null) {
      pinMessage = LabelsClass.setPIN(context);
      print("pinMessage: $pinMessage");
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'images/owl.png',
              fit: BoxFit.contain,
              height: SizeConfig.sixtyMultiplier,
            ),
            Text(
              pinMessage,
              style: Theme.of(context).textTheme.headline2,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(SizeConfig.twentyMultiplier, 0,
                      SizeConfig.twentyMultiplier, SizeConfig.twentyMultiplier),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      pinCircleAvatar(0),
                      pinCircleAvatar(1),
                      pinCircleAvatar(2),
                      pinCircleAvatar(3),
                      pinCircleAvatar(4),
                      pinCircleAvatar(5),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      SizeConfig.twentyMultiplier,
                      SizeConfig.twentyMultiplier,
                      SizeConfig.twentyMultiplier,
                      0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      keypadButton("1"),
                      getWidthSizeBox(SizeConfig.twentyMultiplier),
                      keypadButton("2"),
                      getWidthSizeBox(SizeConfig.twentyMultiplier),
                      keypadButton("3"),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      SizeConfig.twentyMultiplier,
                      SizeConfig.twentyMultiplier,
                      SizeConfig.twentyMultiplier,
                      0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      keypadButton("4"),
                      getWidthSizeBox(SizeConfig.twentyMultiplier),
                      keypadButton("5"),
                      getWidthSizeBox(SizeConfig.twentyMultiplier),
                      keypadButton("6"),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      SizeConfig.twentyMultiplier,
                      SizeConfig.twentyMultiplier,
                      SizeConfig.twentyMultiplier,
                      0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      keypadButton("7"),
                      getWidthSizeBox(SizeConfig.twentyMultiplier),
                      keypadButton("8"),
                      getWidthSizeBox(SizeConfig.twentyMultiplier),
                      keypadButton("9"),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      SizeConfig.twentyMultiplier,
                      SizeConfig.twentyMultiplier,
                      SizeConfig.twentyMultiplier,
                      0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: SizeConfig.fortyMultiplier,
                      ),
                      getWidthSizeBox(SizeConfig.twentyMultiplier),
                      keypadButton("0"),
                      getWidthSizeBox(SizeConfig.twentyMultiplier),
                      GestureDetector(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.backspace,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          radius: SizeConfig.fortyMultiplier,
                        ),
                        onTap: () {
                          setState(() {
                            if (pin.length > 0) {
                              print(pin);
                              pin = pin.substring(0, pin.length - 1);
                              print(pin);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
