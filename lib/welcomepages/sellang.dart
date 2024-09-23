import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../screens/setting_widgets/showlang.dart';

class Lang extends StatefulWidget {
  const Lang({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LangState createState() => _LangState();
}


class _LangState extends State<Lang> {

   @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

   Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    // ignore: unused_local_variable
    final String languageCode = prefs.getString('languageCode') ?? 'en';
    setState(() {
    });
  }

  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'ar':
        return 'العربية';
      case 'af':
        return 'Hausa';
      case 'zu':
        return 'Yoruba';
      case 'sw':
        return 'Igbo';
      default:
        return 'Unknown';
    }
  }

  void _changeLanguage(Locale newLocale) async {
    setState(() {
    });
    GonaVendor.setLocale(context, newLocale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', newLocale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    String getLanguageName(Locale locale) {
      switch (locale.languageCode) {
        case 'en':
          return 'English';
        case 'fr':
          return 'Français';
        case 'ar':
          return 'العربية';
        case 'af':
          return 'Hausa';
        case 'zu':
          return 'Yoruba';
        case 'sw':
          return 'Igbo';
        default:
          return 'Unknown';
      }
    }

    void showLocaleDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const LanguageDialog();
        },
      );
    }

    Locale currentLocale = Localizations.localeOf(context);

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.language,
              color: Colors.black,
              weight: 10,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: GestureDetector(
              onTap: () {
                showLocaleDialog(context);
              },
              child: Text(
                getLanguageName(currentLocale),
                style:
                    GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
                showLocaleDialog(context);
              },
              child: const Icon(
                CupertinoIcons.forward,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
