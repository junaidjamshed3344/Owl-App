import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/View/Model/AuthenticationService.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';
import 'package:provider/provider.dart';

class SignUpSignInScreen extends StatefulWidget {
  @override
  _SignUpSignInScreenState createState() => _SignUpSignInScreenState();
}

class _SignUpSignInScreenState extends State<SignUpSignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();

  bool hidePassword1;
  bool hidePassword2;

  bool isSignUp;

  @override
  void initState() {
    super.initState();
    hidePassword1 = true;
    hidePassword2 = true;
    isSignUp = false;
  }

  Widget getSizeBox() {
    return SizedBox(
      height: SizeConfig.tenMultiplier,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Center(child: Text("Sign Up")),
      ),*/
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: SizeConfig.twentyMultiplier),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: SizeConfig.fiftyMultiplier,
                  child: Image.asset(
                    'images/owl.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Container(
                  //height: SizeConfig.eightHundredMultiplier,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isSignUp
                            ? LabelsClass.createYourAccount(context)
                            : LabelsClass.signInToYourAccount(context),
                        textAlign: TextAlign.start,
                      ),
                      getSizeBox(),
                      Container(
                        width: SizeConfig.twoFiftyMultiplier,
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.tenMultiplier),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.tenMultiplier),
                            ),
                            hintText: LabelsClass.email(context),
                            labelText: LabelsClass.email(context),
                          ),
                          controller: emailController,
                        ),
                      ),
                      getSizeBox(),
                      Container(
                        width: SizeConfig.twoFiftyMultiplier,
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.tenMultiplier),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.tenMultiplier),
                            ),
                            hintText: LabelsClass.password(context),
                            labelText: LabelsClass.password(context),
                            suffixIcon: IconButton(
                              icon: Icon(hidePassword1
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  hidePassword1 = !hidePassword1;
                                });
                              },
                            ),
                          ),
                          controller: passwordController1,
                          obscureText: hidePassword1,
                          enableSuggestions: false,
                          autocorrect: false,
                        ),
                      ),
                      getSizeBox(),
                      Container(
                        child: isSignUp
                            ? Container(
                                width: SizeConfig.twoFiftyMultiplier,
                                child: TextField(
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.tenMultiplier),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.tenMultiplier),
                                    ),
                                    hintText:
                                        LabelsClass.confirmPassword(context),
                                    labelText:
                                        LabelsClass.confirmPassword(context),
                                    suffixIcon: IconButton(
                                      icon: Icon(hidePassword2
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          hidePassword2 = !hidePassword2;
                                        });
                                      },
                                    ),
                                  ),
                                  controller: passwordController2,
                                  obscureText: hidePassword2,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                ),
                              )
                            : null,
                      ),
                      getSizeBox(),
                      Container(
                        width: SizeConfig.twoFiftyMultiplier,
                        child: ElevatedButton(
                          child: Text(isSignUp
                              ? LabelsClass.createYourAccount(context)
                              : LabelsClass.signIn(context)),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.tenMultiplier),
                          ))),
                          onPressed: () async {
                            if (isSignUp) {
                              if (passwordController1.text ==
                                  passwordController2.text) {
                                bool isSuccessful = await context
                                    .read<AuthenticationService>()
                                    .signUp(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController1.text.trim());
                                if (isSuccessful) {
                                  //Controller.setEmailForRegisteredUser(emailController.text.trim());
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      LabelsClass.userRegistered(context),
                                    ),
                                    duration: Duration(seconds: 3),
                                  ));
                                  Controller.createFirstItemsOnSignUp();
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      LabelsClass.registrationFailed(context),
                                    ),
                                    duration: Duration(seconds: 3),
                                  ));
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    LabelsClass.passwordsDoNotMatch(context),
                                  ),
                                  duration: Duration(seconds: 3),
                                ));
                              }
                            } else {
                              bool isSuccessful = await context
                                  .read<AuthenticationService>()
                                  .signIn(
                                      email: emailController.text.trim(),
                                      password:
                                          passwordController1.text.trim());
                              if (!isSuccessful) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    LabelsClass.signInFailed(context),
                                  ),
                                  duration: Duration(seconds: 3),
                                ));
                              }
                            }
                          },
                        ),
                      ),
                      getSizeBox(),
                      Container(
                        width: SizeConfig.twoFiftyMultiplier,
                        child: ElevatedButton(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/google_logo.png',
                                fit: BoxFit.fitHeight,
                                height: SizeConfig.twentyMultiplier,
                              ),
                              Text(
                                LabelsClass.signInWithGoogle(context),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              Text(""),
                            ],
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.tenMultiplier),
                              ))),
                          onPressed: () async {
                            /*UserCredential uc = */ await context
                                .read<AuthenticationService>()
                                .signInWithGoogle();
                            //Controller.setEmailForRegisteredUser(uc.additionalUserInfo.username);
                          },
                        ),
                      ),
                      getSizeBox(),
                      Container(
                        width: SizeConfig.twoFiftyMultiplier,
                        child: ElevatedButton(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/facebook_logo.png',
                                fit: BoxFit.fitHeight,
                                height: SizeConfig.twentyMultiplier,
                              ),
                              Text(
                                LabelsClass.signInWithFacebook(context),
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              ),
                              Text(""),
                            ],
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blueAccent),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.tenMultiplier),
                              ))),
                          onPressed: () async {
                            /*UserCredential uc = */ await context
                                .read<AuthenticationService>()
                                .signInWithFacebook();
                            //Controller.setEmailForRegisteredUser(uc.additionalUserInfo.username);
                          },
                        ),
                      ),
                      getSizeBox(),
                      Text(
                        LabelsClass.or(context),
                        style: TextStyle(fontSize: SizeConfig.twelveMultiplier),
                        textAlign: TextAlign.start,
                      ),
                      getSizeBox(),
                      Container(
                        width: SizeConfig.twoFiftyMultiplier,
                        child: ElevatedButton(
                          child: Text(isSignUp
                              ? LabelsClass.signIn(context)
                              : LabelsClass.signUp(context)),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.tenMultiplier),
                          ))),
                          onPressed: () {
                            setState(() {
                              isSignUp = !isSignUp;
                            });
                          },
                        ),
                      ),
                    ],
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
