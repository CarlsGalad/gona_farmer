import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'showlang.dart';

class SelectLang extends StatefulWidget {
  const SelectLang({super.key});

  @override
  State<SelectLang> createState() => _SelectLangState();
}

class _SelectLangState extends State<SelectLang> {
  @override
  Widget build(BuildContext context) {
    return
        // language setting starts here
        Padding(
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
                    'Languages',
                    style: GoogleFonts.sansita(
                      fontSize: 17,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Text(
                    getSelectedLanguage(context),
                  ),
                )
              ],
            ),
            const Spacer(),
            // change language
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: () {
                  _showLanguageDialog(context);
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

void _showLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const LanguageDialog(); // Show language selection dialog
    },
  );
}
