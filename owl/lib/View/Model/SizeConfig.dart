import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static double screenWidth;
  static double screenHeight;

  // height multipliers
  static double fiveMultiplier;
  static double tenMultiplier;
  static double twelveMultiplier;
  static double fifteenMultiplier;
  static double eighteenMultiplier;
  static double twentyMultiplier;
  static double twentyFiveMultiplier;
  static double thirtyMultiplier;
  static double thirtyFiveMultiplier;
  static double fortyMultiplier;
  static double fiftyMultiplier;
  static double sixtyMultiplier;
  static double seventyFiveMultiplier;
  static double oneHundredMultiplier;
  static double oneTwentyFiveMultiplier;
  static double oneFiftyMultiplier;
  static double oneSeventyFiveMultiplier;
  static double twoFiftyMultiplier;
  static double threeHundredMultiplier;
  static double threeFiftyMultiplier;

  // width multipliers
  static double widthEighteenMultiplier;

  // static bool isPortrait = true;
  // static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    /*if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }*/

    screenHeight = constraints.maxHeight;
    screenWidth = constraints.maxWidth;

    // these sizes are for height: 759.272
    fiveMultiplier = constraints.maxHeight * 0.0065;
    tenMultiplier = constraints.maxHeight * 0.0131;
    twelveMultiplier = constraints.maxHeight * 0.0158;
    fifteenMultiplier = constraints.maxHeight * 0.0197;
    eighteenMultiplier = constraints.maxHeight * 0.0237;
    twentyMultiplier = constraints.maxHeight * 0.0263;
    twentyFiveMultiplier = constraints.maxHeight * 0.0329;
    thirtyMultiplier = constraints.maxHeight * 0.0395;
    thirtyFiveMultiplier = constraints.maxHeight * 0.0460;
    fortyMultiplier = constraints.maxHeight * 0.0526;
    fiftyMultiplier = constraints.maxHeight * 0.0658;
    sixtyMultiplier = constraints.maxHeight * 0.0790;
    seventyFiveMultiplier = constraints.maxHeight * 0.0988;
    oneHundredMultiplier = constraints.maxHeight * 0.1317;
    oneTwentyFiveMultiplier = constraints.maxHeight * 0.1646;
    oneFiftyMultiplier = constraints.maxHeight * 0.1975;
    oneSeventyFiveMultiplier = constraints.maxHeight * 0.2304;
    twoFiftyMultiplier = constraints.maxHeight * 0.3293;
    threeHundredMultiplier = constraints.maxHeight * 0.3951;
    threeFiftyMultiplier = constraints.maxHeight * 0.4609;

    // these sizes are for width: 392.727
    widthEighteenMultiplier = constraints.maxWidth * 0.0458;

    print("height: ${constraints.maxHeight}");
    print("width: ${constraints.maxWidth}");
  }
}
