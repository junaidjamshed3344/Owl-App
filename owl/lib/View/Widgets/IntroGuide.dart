import 'package:flutter/cupertino.dart';
import 'package:flutter_intro/flutter_intro.dart';

class IntroGuide {

  static Intro intro; // includes parent reward screen
  static Intro profileIntro;
  static Intro addProfileIntro;
  static Intro testsIntro;
  static Intro childRewardIntro;
  static Intro childTestIntro;

  static void initializeAll() {
    initializeHomeAndRewardScreenIntro();
    initializeProfileScreenIntro();
    initializeAddProfileScreenIntro();
    initializeTestsScreenIntro();
    initializeChildRewardIntro();
    initializeChildTestIntro();
  }

  static void initializeHomeAndRewardScreenIntro() {
    intro = Intro(
      /// You can set it true to disable animation
      noAnimation: false,

      /// The total number of guide pages, must be passed
      stepCount: 7,

      /// The padding of the highlighted area and the widget
      padding: EdgeInsets.all(8),

      /// Border radius of the highlighted area
      borderRadius: BorderRadius.all(Radius.circular(4)),

      /// Use the default useDefaultTheme provided by the library to quickly build a guide page
      /// Need to customize the style and content of the guide page, implement the widgetBuilder method yourself
      widgetBuilder: StepWidgetBuilder.useDefaultTheme(
        /// Guide page text
        texts: [
          "You are currently on the Rewards Screen. Tap this to come back to Rewards screen if you are on some other screen.",
          "Tap this to go to Profiles screen.",
          "Tap this to go to Tests Screen.",
          "Tap this to go to Settings.",
          "Tap this to go to the Child Mode.",
          "When on rewards screen, press this button to add a new reward.",
          "Tap on a task after it has been completed to reward the minutes.\nTap and hold on a task to edit its details.\nTap and slide a task sideways to delete it.\nAn orange mark next to a task will show that the child has completed that task and your approval is required."
        ],
        /// Button text
        buttonTextBuilder: (curr, total) {
          return curr < total - 1 ? 'Next' : 'Finish';
        },
        /// Click on whether the mask is allowed to be closed.
        //maskClosable: true,
      ),
    );
  }

  static void initializeProfileScreenIntro() {
    profileIntro = Intro(
      noAnimation: false,

      /// The total number of guide pages, must be passed
      stepCount: 4,

      padding: EdgeInsets.all(8),
      borderRadius: BorderRadius.all(Radius.circular(4)),
      widgetBuilder: StepWidgetBuilder.useDefaultTheme(
        texts: [
          "This an app blocking profile which is identified by its name on the top left corner.\nTap on the profile to view and edit its details.\nTap and slide the profile sideways to delete it.",
          "These are the applications included in this profile.",
          "This profile will block applications on the day/s mentioned here.",
          "Tap the 'Activate' button to start blocking applications.\n\n\nLet's start by tapping the '+' button below to create a new profile."
        ],
        buttonTextBuilder: (curr, total) {
          return curr < total - 1 ? 'Next' : 'Finish';
        },
      ),
    );
  }

  static void initializeAddProfileScreenIntro() {
    addProfileIntro = Intro(
      noAnimation: false,

      /// The total number of guide pages, must be passed
      stepCount: 6,

      padding: EdgeInsets.all(8),
      borderRadius: BorderRadius.all(Radius.circular(4)),
      widgetBuilder: StepWidgetBuilder.useDefaultTheme(
        texts: [
          "Enter the profile name.",
          "Select a blocking mode.\n\nWhitelist mode will block all the applications in your device except for the ones that are included in the profile.\n\nBlacklist mode will only block the applications that have been included in the profile.",
          "Select applications to include in the profile by tapping the '+' button.",
          "Select a time duration for the profile to work during the day. You can select 24 hours or add a time range of your choice by tapping the '+' button.\nTo delete a time slot, simply tap and slide it sideways.",
          "Here you can see the days that are available to choose. The days that are not available are greyed out. And the available days are pre-selected. You can tap to select and un-select a day.",
          "After adding all the required data, tap this button to save the new profile."
        ],
        buttonTextBuilder: (curr, total) {
          return curr < total - 1 ? 'Next' : 'Finish';
        },
      ),
    );
  }

  static void initializeTestsScreenIntro() {
    testsIntro = Intro(
      noAnimation: false,

      /// The total number of guide pages, must be passed
      stepCount: 2,

      padding: EdgeInsets.all(8),
      borderRadius: BorderRadius.all(Radius.circular(4)),
      widgetBuilder: StepWidgetBuilder.useDefaultTheme(
        texts: [
          "This is a Test object. You can tap it to see and edit the Multiple Choice Questions that are included in this test.\nTap and hold to edit its details.",
          "You can activate/deactivate a test by pressing this button, and then the child will be able to attempt the test once."
        ],
        buttonTextBuilder: (curr, total) {
          return curr < total - 1 ? 'Next' : 'Finish';
        },
      ),
    );
  }

  static void initializeChildRewardIntro() {
    childRewardIntro = Intro(
      noAnimation: false,

      /// The total number of guide pages, must be passed
      stepCount: 4,

      padding: EdgeInsets.all(8),
      borderRadius: BorderRadius.all(Radius.circular(4)),
      widgetBuilder: StepWidgetBuilder.useDefaultTheme(
        texts: [
          "'Max Usage Limit' show the number of minutes that are allowed to use while the applications are blocked",
          "'Total Rewards' show the available minutes to use when the applications are blocked",
          "When the applications are blocked, you can use the available minutes by pressing this button",
          "Here the tasks are shown with the minutes that will be rewarded for completing them.\nWhen a task has been completed, you can press the 'Complete' button next to it, to get approval.\nA task that has been approved will be shown with a dark background."
        ],
        buttonTextBuilder: (curr, total) {
          return curr < total - 1 ? 'Next' : 'Finish';
        },
      ),
    );
  }

  static void initializeChildTestIntro() {
    childTestIntro = Intro(
      noAnimation: false,

      /// The total number of guide pages, must be passed
      stepCount: 1,

      padding: EdgeInsets.all(8),
      borderRadius: BorderRadius.all(Radius.circular(4)),
      widgetBuilder: StepWidgetBuilder.useDefaultTheme(
        texts: [
          "This is a test that will reward minutes if successfully attempted.\nWhen a test is active, a 'Start Test' button will be shown and you can attempt it once.\nYou will be rewarded minutes for answering all questions correctly."
        ],
        buttonTextBuilder: (curr, total) {
          return 'Okay';
        },
      ),
    );
  }
}