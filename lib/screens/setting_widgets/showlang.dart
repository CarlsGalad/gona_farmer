import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/languges.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({super.key});

  Future<void> _changeLanguage(BuildContext context, Language language) async {
    Locale locale = Locale(language.languagCode);
    GonaVendor.setLocale(
        context, locale); 
    Navigator.of(context).pop(); // Close the dialog
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Language'),
      content: SingleChildScrollView(
        child: ListBody(
          children: Language.languageList().map((language) {
            return GestureDetector(
              onTap: () => _changeLanguage(context, language),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(child: Text(language.name)),
              ),
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
