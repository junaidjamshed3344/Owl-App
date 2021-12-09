import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owl/View/Model/LabelsClass.dart';
import 'package:owl/View/Model/SizeConfig.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreen createState() => _HelpScreen();
}

class _HelpScreen extends State<HelpScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Center(child: Text(LabelsClass.faqs(context))),
        actions: [
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.fifteenMultiplier),
            child: Icon(Icons.clear, color: Theme.of(context).primaryColor),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.twentyMultiplier),
              topRight: Radius.circular(SizeConfig.twentyMultiplier)),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  getListItem(context, "What is a Reward, and how to create it?", "A) A reward is the number of minutes that you add for a task that needs to be completed. When a task has been completed, you can award those rewards to the child. To add a new reward or task, go to the Parents' module by signing into your account and press the '+' button at the bottom bar and then enter the task and the reward minutes."),
                  getListItem(context, "How to activate a reward?", "A) You can activate a reward by tapping on its icon. The icon will turn green when its activated. When a child has completed a task, they can press the ‘Complete’ button that will notify the parent to activate the reward."),
                  getListItem(context, "What is a Profile, and how to create it?", "A) A profile or blocking profile contains the information about the applications and when to block them. To add a new profile, go to the Parents' module by signing into your account. Then press the second icon (clipboard) on the bottom bar and then press ‘+’ button. A new screen will open. Add a name for your profile, select a mode either blacklist or whitelist, select the applications that need to be blocked, and then select the days and time for the profile to work. Then press the check mark button and the profile will be created."),
                  getListItem(context, "What is Blacklist and Whitelist mode?", "A) When blacklist mode is selected, all the applications within that profile will be blocked. When whitelist mode is selected, all the applications within that profile will not be blocked, but all others will be blocked."),
                  getListItem(context, "How to activate a profile?", "A) Go to the Profiles Screen in Parents module and then press the ‘Activate’ button to activate the profile. Once activated, the profile will start blocking applications on the time selected."),
                  getListItem(context, "What is a test, and how to create it?", "A) A test contains Multiple Choice Questions and a reward that would be awarded if the child attempts the test correctly. To create a test, go to the Tests Screen in parents’ module and then press the ‘+’ button to create a test. Enter a Title for the test and the reward minutes to be awarded. Save the test and then tap on it to start entering the questions. Press the ‘+’ button on the bottom to add a new question. Each question has 6 parts: The question, 4 options and 1 correct option. After entering the question and the 4 choices, select the correct option for the answer and press ‘Save’, and the question will be added. Add as many questions as you like."),
                  getListItem(context, "How to activate a test?", "A) Press the green check mark to activate the test. Once the test has been activated, the child can attempt it once. But the parent can re-activate the test if they want."),
                  getListItem(context, "How to set the Max Usage Limit?", "A) Max Usage Limit is the maximum number of minutes or hours that the child will be able to use in a day. To set a limit go to settings in Parents’ module and select the hours or minutes for the limit."),
                  getListItem(context, "How to stop the child from uninstalling OWL?", "A) ${LabelsClass.uninstallGuide1(context)}\n${LabelsClass.uninstallGuide2(context)}\n${LabelsClass.uninstallGuide3(context)}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget getListItem(context, title, child) {
  return ExpansionTile(
    leading: Icon(
      Icons.help_rounded,
      color: Theme.of(context).primaryColor,
    ),
    title: Text(
      title,
      style: Theme.of(context).textTheme.bodyText2,
    ),
    children: [
      Padding(
        padding: EdgeInsets.all(SizeConfig.tenMultiplier),
        child: Text(
          child,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      )
    ],
  );
}
