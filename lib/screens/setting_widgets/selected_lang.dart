import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'showlang.dart';

class SelectLang extends StatelessWidget {
  const SelectLang({super.key});

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
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(184, 181, 181, 1),
                offset: Offset(2, 2),
                blurRadius: 4.0,
                spreadRadius: 1.0,
                blurStyle: BlurStyle.normal),
            BoxShadow(
              color: Color.fromRGBO(255, 255, 255, 0.9),
              offset: Offset(-0, -1),
              blurRadius: 5.0,
              spreadRadius: 1.0,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.language,
                color: Colors.green,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    AppLocalizations.of(context)!.languages,
                    style: GoogleFonts.sansita(
                      fontSize: 17,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Text(getLanguageName(currentLocale)),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: () {
                  showLocaleDialog(context);
                },
                child: const Icon(
                  CupertinoIcons.forward,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
