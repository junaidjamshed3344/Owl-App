import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/Localization/OwlLocalization.dart';
import 'package:owl/Model/SharedPrefs.dart';
import 'package:owl/View/Model/basicTheme.dart';
import 'package:owl/View/Screens/SplashScreen.dart';
import 'package:provider/provider.dart';

import 'View/Model/AuthenticationService.dart';
import 'View/Model/SizeConfig.dart';
import 'View/Widgets/IntroGuide.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await MobileAds.instance.initialize();
  await SharedPrefs.init();
  Controller.variablesToInitializeDatabase();

  /*if (Controller.splashScreenToIsFirstTime() != 0) {
    // do not call first time
    await Controller.parentScreenToRewardListInitializer();
    await Controller.profileScreenToProfileListInitializer();
  }*/

  IntroGuide.initializeAll();

  //Controller.profileDataInputScreenToGetDayStatus();
  var firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser != null) {
    Controller.rewardListStatusInit();
    Controller.initializeVariablesFromFirebase2();
    await Controller.checkRewardStatusInit();
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  @override
  void initState() {
    //Controller.initializeVariablesFromFirebase();
    /*if (SharedPrefs.prefs.getInt('REWARD_TIME') == null) {
      SharedPrefs.prefs.setInt('REWARD_TIME', 0);
      Variables.rewardTotalMinutes = 0;
    } else {
      Variables.rewardTotalMinutes = SharedPrefs.prefs.getInt('REWARD_TIME');
    }
    if (SharedPrefs.prefs.getInt('REWARDS_STATUS') == null) {
      SharedPrefs.prefs.setInt('REWARDS_STATUS', 1);
      Variables.rewardStatus = 1;
    } else {
      Variables.rewardStatus = SharedPrefs.prefs.getInt('REWARDS_STATUS');
    }
    if (SharedPrefs.prefs.getInt('MAX_LIMIT') == null) {
      SharedPrefs.prefs.setInt('MAX_LIMIT', 0);
      Variables.rewardMaxLimit = 0;
    } else {
      Variables.rewardMaxLimit = SharedPrefs.prefs.getInt('MAX_LIMIT');
    }*/

    Locale l = Controller.settingsScreenToGetLanguage();
    if (l != null) {
      _locale = l;
    }

    /*if (SharedPrefs.prefs.getInt("PREV_DAY_REWARD") == null) {
      SharedPrefs.prefs.setInt("PREV_DAY_REWARD", DateTime.now().day - 5);
    }

    if (SharedPrefs.prefs.getInt("PREV_DAY_PARENT_REWARD") == null) {
      SharedPrefs.prefs
          .setInt("PREV_DAY_PARENT_REWARD", DateTime.now().day - 5);
    }*/
    super.initState();

    Controller.initFirebaseMessagingForNotifications();
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    // to force portrait mode
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // https://flutter.dev/docs/cookbook/navigation/named-routes
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MultiProvider(
              providers: [
                Provider<AuthenticationService>(
                  create: (_) => AuthenticationService(FirebaseAuth.instance),
                ),
                StreamProvider(
                  create: (context) =>
                      context.read<AuthenticationService>().authStateChanges,
                  initialData: null,
                ),
              ],
              child: MaterialApp(
                title: 'Owl',
                theme: basicTheme(),
                locale: _locale,
                localizationsDelegates: [
                  OwlLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale('en', 'US'), // English, no country code
                  const Locale('de', 'DE'), // German
                ],
                initialRoute: '/',
                localeResolutionCallback: (deviceLocale, supportedLocales) {
                  for (var locale in supportedLocales) {
                    if (Controller.settingsScreenToGetLanguage() == null) {
                      if (locale.languageCode == deviceLocale.languageCode &&
                          locale.countryCode == deviceLocale.countryCode) {
                        Controller.settingsScreenToSetLanguage(
                            locale.languageCode, locale.countryCode);
                        return deviceLocale;
                      }
                    } else {
                      return Controller.settingsScreenToGetLanguage();
                    }
                  }
                  Controller.settingsScreenToSetLanguage(
                      supportedLocales.first.languageCode,
                      supportedLocales.first.countryCode);
                  return supportedLocales.first;
                },
                routes: {
                  '/': (context) => SplashScreen(),
                },
              ),
            );
          },
        );
      },
    );
  }
}
