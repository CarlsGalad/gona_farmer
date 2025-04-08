import 'package:flutter/material.dart';
import 'package:gona_vendor/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';
import '../../models/languages.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({super.key});

  Future<void> _changeLanguage(BuildContext context, Language language) async {
    Locale locale = Locale(language.languageCode);
    GonaVendor.setLocale(context, locale);
    Navigator.of(context).pop(); // Close the dialog
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      
      title: Center(
          child: Text('Select Language',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 20))),
      content: SingleChildScrollView(
        child: ListBody(
          children: Language.languageList().map((language) {
            return GestureDetector(
              onTap: () => _changeLanguage(context, language),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                    child: Text(
                  language.name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                  ),
                )),
              ),
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
