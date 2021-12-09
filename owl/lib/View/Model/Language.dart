import 'package:flutter/cupertino.dart';
import 'package:owl/Controller/Controller.dart';
import 'package:owl/main.dart';

class Language {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  Language(this.id, this.name, this.flag, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, 'English', '🇺🇸', 'en'),
      Language(2, 'German', '🇩🇪', 'de'),
    ];
  }

  static changeLanguage(
      BuildContext context, String languageCode, String countryCode) {
    MyApp.setLocale(context, Locale(languageCode, countryCode));
    Controller.settingsScreenToSetLanguage(languageCode, countryCode);
  }
}
