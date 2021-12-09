import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';

import 'PermissionScreen.dart';

class InformationScreen extends StatefulWidget {
  @override
  _InformationScreenState createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  int pageNumber = 1;

  ButtonStyle getButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.tenMultiplier),
        ),
      ),
    );
  }

  Widget getProgressDots(int number) {
    return Icon(Icons.circle,
        color: pageNumber == number
            ? Theme.of(context).primaryColorDark
            : Theme.of(context).primaryColorLight);
  }

  Widget getImage() {
    String imagePath = "images/intro1.png";
    if (pageNumber == 2) {
      imagePath = "images/intro2.png";
    } else if (pageNumber == 3) {
      imagePath = "images/intro3.png";
    } else if (pageNumber == 4) {
      imagePath = "images/intro4.png";
    } else if (pageNumber == 5) {
      imagePath = "images/intro5.png";
    } else if (pageNumber == 6) {
      imagePath = "images/intro6.png";
    } else if (pageNumber == 7) {
      imagePath = "images/intro7.png";
    } else if (pageNumber == 8) {
      imagePath = "images/intro8.png";
    }
    return Image.asset(
      imagePath,
      fit: BoxFit.fitHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              //height: SizeConfig.threeFiftyMultiplier,
              padding: EdgeInsets.all(SizeConfig.fifteenMultiplier),
              child: getImage(),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: pageNumber == 1
                ? Text("")
                : ElevatedButton(
                    child: Text(LabelsClass.back(context)),
                    style: getButtonStyle(),
                    onPressed: () {
                      setState(() {
                        if (pageNumber > 1) {
                          pageNumber--;
                        }
                      });
                    },
                  ),
          ),
          Positioned(
            bottom: 10,
            right: 20,
            child: ElevatedButton(
              child: Text(pageNumber < 8
                  ? LabelsClass.next(context)
                  : LabelsClass.finish(context)),
              style: getButtonStyle(),
              onPressed: () {
                setState(() {
                  pageNumber++;
                  if (pageNumber == 9) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PermissionScreen(),
                      ),
                    );
                  }
                });
              },
            ),
          ),
          Positioned.fill(
            bottom: 10,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getProgressDots(1),
                  getProgressDots(2),
                  getProgressDots(3),
                  getProgressDots(4),
                  getProgressDots(5),
                  getProgressDots(6),
                  getProgressDots(7),
                  getProgressDots(8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
