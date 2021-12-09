import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/View/Model/AuthenticationService.dart';
import 'package:owl/View/Model/AuthenticationWrapper.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';
import 'package:owl/View/Widgets/ConfirmCredentialsDialog.dart';
import 'package:provider/provider.dart';

import 'RegisterPIN.dart';

class InputPIN extends StatefulWidget {
  int calledFrom = 0;

  // 0 for lock screen
  // 1 for settings (to change pin code)
  InputPIN(this.calledFrom);

  @override
  _InputPIN createState() => _InputPIN();
}

class _InputPIN extends State<InputPIN> {
  String pin = "";
  String pinMessage;
  bool showLoading = false;

  /*InterstitialAd inputPINInterstitialAd = InterstitialAd(
    adUnitId: 'ca-app-pub-3940256099942544/1033173712',
    request: AdRequest(),
    listener: AdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        print('Ad loaded.');
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        print('Ad failed to load: $error');
        ad.dispose();
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) {
        print('Ad closed.');
        ad.dispose();
      },
      // Called when an ad is in the process of leaving the application.
      onApplicationExit: (Ad ad) {
        print('Left application.');
        ad.dispose();
      },
    ),
  );*/

  @override
  void initState() {
    // Find reason for this sleep
    //sleep(Duration(milliseconds: 500));

    //inputPINInterstitialAd.load();

    super.initState();
  }

  Widget getWidthSizeBox(double height) {
    return SizedBox(
      width: height,
    );
  }

  void showProgressIndicator() {
    setState(() {
      print("Show Loading");
      showLoading = true;
    });
  }

  Future<void> automaticLogin() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      if (Controller.getLoginType() == 0) {
        String email = Controller.getEmail();
        if (email != null) {
          String password = Controller.getPassword();
          if (password != null) {
            await context
                .read<AuthenticationService>()
                .signIn(email: email, password: password);
          }
        }
      }
    }
  }

  void checkPIN() async {
    if (pin.length == 6) {
      if (Controller.inputPinToAuthenticatePin(pin) == 0) {
        showProgressIndicator();
        //inputPINInterstitialAd.show();
        await automaticLogin();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => widget.calledFrom == 0
                  ? AuthenticationWrapper()
                  : RegisterPIN(1),
            ));
      } else {
        setState(() {
          pin = "";
          pinMessage = LabelsClass.incorrectPin(context);
          print("pinMessage: $pinMessage");
        });
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
          : Icon(
              Icons.adjust_rounded,
              size: SizeConfig.thirtyMultiplier,
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
      pinMessage = widget.calledFrom == 0
          ? LabelsClass.enterPIN(context)
          : LabelsClass.confirmPIN(context);
      print("pinMessage: $pinMessage");
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: showLoading,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  pinMessage,
                  style: Theme.of(context).textTheme.headline2,
                ),
                Container(
                  padding: EdgeInsets.all(SizeConfig.twentyMultiplier),
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
                Container(
                  padding: EdgeInsets.fromLTRB(
                      SizeConfig.twentyMultiplier,
                      SizeConfig.twentyMultiplier,
                      SizeConfig.twentyMultiplier,
                      0),
                  child: TextButton(
                    child: Text(
                      LabelsClass.forgotPIN(context),
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onPressed: () async {
                      int credentialStatus = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmCredentialsDialog();
                        },
                      );
                      if (credentialStatus != null) {
                        String message = "";
                        if (credentialStatus == 0) {
                          // credentials okay
                          message = "Credentials Confirmed";
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPIN(1),
                              ));
                        } else if (credentialStatus == 1) {
                          // wrong email
                          message = "Incorrect Email";
                        } else if (credentialStatus == 2) {
                          // wrong password
                          message = "Incorrect Password";
                        }
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            message,
                          ),
                          duration: Duration(seconds: 3),
                        ));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
