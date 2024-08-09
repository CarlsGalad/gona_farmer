import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ServiceTerms extends StatelessWidget {
  const ServiceTerms({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.book,
                color: Colors.green.shade300,
                size: 20,
              ),
            ),
            Text(AppLocalizations.of(context)!.terms_of_service,
                style: GoogleFonts.sansita(fontSize: 18)),
            const Spacer(),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      title: Text(
                        AppLocalizations.of(context)!.terms_of_service,
                        style: GoogleFonts.bebasNeue(fontSize: 20),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.intro,
                              textAlign: TextAlign.justify,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppLocalizations.of(context)!.section1_title,
                                style: GoogleFonts.sansita(fontSize: 15),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.section2_content,
                              textAlign: TextAlign.justify,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppLocalizations.of(context)!.section2_title,
                                style: GoogleFonts.sansita(fontSize: 15),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.section2_content,
                              textAlign: TextAlign.justify,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppLocalizations.of(context)!.section3_title,
                                style: GoogleFonts.sansita(fontSize: 15),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.section3_content,
                              textAlign: TextAlign.justify,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppLocalizations.of(context)!.contact_us,
                                style: GoogleFonts.sansita(fontSize: 15),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.contact_detailst,
                              textAlign: TextAlign.justify,
                            )
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            AppLocalizations.of(context)!.close,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    );
                  },
                );
                // Navigate to Privacy Policy screen
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  CupertinoIcons.forward,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
