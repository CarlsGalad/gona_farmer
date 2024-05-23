import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import the generated localization files
import 'package:gona_vendor/ha_intl.dart';
import 'package:gona_vendor/ig_intl.dart';
import 'package:gona_vendor/yo_intl.dart';



import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String LANGUAGE_CODE = 'languageCode';

// languages code
const String ENGLISH = 'en';
const String ARABIC = 'ar';
const String HAUSA = 'ha';
const String YORUBA = 'yo';
const String IGBO = 'ig';
const String FRENCH = 'fr';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(LANGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = prefs.getString(LANGUAGE_CODE) ?? ENGLISH;
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
    case FRENCH:
      return const Locale(FRENCH, 'FR');
    default:
      return const Locale(ENGLISH, 'US');
  }
}

AppLocalizations translate(BuildContext, context) {
  return AppLocalizations.of(context)!;
}
