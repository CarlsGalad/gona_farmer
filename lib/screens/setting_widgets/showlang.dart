import 'package:flutter/material.dart';

import 'package:gona_vendor/main.dart';
import 'package:gona_vendor/models/language_const.dart';
import 'package:gona_vendor/models/languges.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Language>(
      hint: const Text('Change Language'),
      onChanged: (Language? language) async {
        if (language != null) {
          Locale _locale = await setLocale(language.languagCode);
          GonaVendor.setLocale(context, _locale);
        }
      },
      items: Language.languageList()
          .map<DropdownMenuItem<Language>>(
            (e) => DropdownMenuItem<Language>(
              value: e,
              child: Text(e.name),
            ),
          )
          .toList(),
    );
  }
}
