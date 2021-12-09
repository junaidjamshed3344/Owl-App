import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/View/Screens/HomeScreen.dart';
import 'package:owl/View/Screens/SignUpSignInScreen.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      Controller.profileDataInputScreenToGetDayStatus();
      return HomeScreen();
    }
    return SignUpSignInScreen();
  }
}
