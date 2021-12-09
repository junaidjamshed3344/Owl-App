import 'package:flutter/cupertino.dart';
import 'package:owl/Localization/OwlLocalization.dart';

String getTranslatedText(BuildContext context, String key) {
  return OwlLocalizations.of(context).getTranslatedValue(key);
}
