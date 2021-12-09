import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/View/Model/AuthenticationService.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';
import 'package:provider/provider.dart';

class ConfirmCredentialsDialog extends StatefulWidget {
  @override
  _ConfirmCredentialsDialogState createState() =>
      _ConfirmCredentialsDialogState();
}

class _ConfirmCredentialsDialogState extends State<ConfirmCredentialsDialog> {
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(SizeConfig.twentyMultiplier))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            LabelsClass.email(context),
            style: Theme.of(context).textTheme.bodyText2,
          ),
          TextFormField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
            onChanged: (value) {
              email = value;
            },
            style: Theme.of(context).textTheme.bodyText2,
            decoration: InputDecoration(
                errorStyle: TextStyle(
              fontSize: SizeConfig.twelveMultiplier,
            )),
          ),
          SizedBox(
            height: SizeConfig.fortyMultiplier,
          ),
          Text(
            LabelsClass.password(context),
            style: Theme.of(context).textTheme.bodyText2,
          ),
          TextFormField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.visiblePassword,
            maxLines: 1,
            onChanged: (value) {
              password = value;
            },
            style: Theme.of(context).textTheme.bodyText2,
            decoration: InputDecoration(
                errorStyle: TextStyle(
              fontSize: SizeConfig.twelveMultiplier,
            )),
          ),
          SizedBox(
            height: SizeConfig.tenMultiplier,
          ),
          Container(
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
                var uc = await context
                    .read<AuthenticationService>()
                    .signInWithGoogle();
                if (uc != null) {
                  Navigator.of(context).pop(0);
                }
                //Controller.setEmailForRegisteredUser(uc.additionalUserInfo.username);
              },
            ),
          ),
          SizedBox(
            height: SizeConfig.tenMultiplier,
          ),
          Container(
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
                var uc = await context
                    .read<AuthenticationService>()
                    .signInWithFacebook();
                if (uc != null) {
                  Navigator.of(context).pop(0);
                }
                //Controller.setEmailForRegisteredUser(uc.additionalUserInfo.username);
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            LabelsClass.cancel(context),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            LabelsClass.ok(context),
          ),
          onPressed: () {
            if (email == Controller.getEmail()) {
             if (password == Controller.getPassword()) {
               Navigator.of(context).pop(0);
             } else {
               Navigator.of(context).pop(2);
             }
            } else {
              Navigator.of(context).pop(1);
            }
          },
        ),
      ],
    );
  }
}
