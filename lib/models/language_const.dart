import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LANGUAGE_CODE = 'languageCode';

// languages code
const String ENGLISH = 'en';
const String ARABIC = 'ar';
const String HAUSA = 'ha';
const String YORUBA = 'yr';
const String IGBO = 'ig';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LANGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LANGUAGE_CODE) ?? ENGLISH;
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, 'US');
    case ARABIC:
      return const Locale(ARABIC, 'SA');
    case HAUSA:
      return const Locale(HAUSA, 'NG');
    case YORUBA:
      return const Locale(YORUBA, 'NG');
    case IGBO:
      return const Locale(IGBO, 'NG');
    default:
      return const Locale(ENGLISH, 'US');
  }
}

// // TODO: implement this
// AppLocalizations translate(BuildContext, context) {
//   return AppLocalizations.of(context)!;
// }
