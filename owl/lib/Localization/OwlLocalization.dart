import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class OwlLocalizations {
  OwlLocalizations(this.locale);

  final Locale locale;
  static Map<String, String> _localizedValues;
  static const LocalizationsDelegate<OwlLocalizations> delegate =
      _OwlLocalizationsDelegate();

  static OwlLocalizations of(BuildContext context) {
    return Localizations.of<OwlLocalizations>(context, OwlLocalizations);
  }

  Future load() async {
    print(locale.languageCode);
    String jsonStringValues =
        await rootBundle.loadString('Lang/${locale.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String getTranslatedValue(String key) {
    return _localizedValues[key];
  }
}

class _OwlLocalizationsDelegate
    extends LocalizationsDelegate<OwlLocalizations> {
  const _OwlLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'de'].contains(locale.languageCode);
  }

  @override
  Future<OwlLocalizations> load(Locale locale) async {
    OwlLocalizations localization = new OwlLocalizations(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(_OwlLocalizationsDelegate old) => false;
}
