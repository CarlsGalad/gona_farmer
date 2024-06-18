import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Policy extends StatelessWidget {
  const Policy({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8, top: 16),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(184, 181, 181, 1),
              offset: Offset(5, 2),
              blurRadius: 6.0,
              spreadRadius: 3.0,
              blurStyle: BlurStyle.normal,
            ),
            BoxShadow(
              color: Color.fromRGBO(255, 255, 255, 0.9),
              offset: Offset(-6, -2),
              blurRadius: 5.0,
              spreadRadius: 3.0,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.policy,
                  color: Colors.green,
                  size: 20,
                ),
              ),
              Text(AppLocalizations.of(context)!.privacy_policy,
                  style: GoogleFonts.sansita(fontSize: 18)),
              const Spacer(),
              GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Center(
                              child: Text(
                            AppLocalizations.of(context)!.privacy_policy,
                            style: GoogleFonts.bebasNeue(),
                          )),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                    AppLocalizations.of(context)!.policy_intro),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .info_we_collect,
                                    style: GoogleFonts.sansita(fontSize: 20),
                                  ),
                                ),
                                Text(AppLocalizations.of(context)!
                                    .collect_details),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .how_we_use_info,
                                    style: GoogleFonts.sansita(fontSize: 20),
                                  ),
                                ),
                                Text(
                                    ''' ${AppLocalizations.of(context)!.use_details}'''),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    AppLocalizations.of(context)!.sharing_info,
                                    style: GoogleFonts.sansita(fontSize: 20),
                                  ),
                                ),
                                Text(
                                    ''''${AppLocalizations.of(context)!.sharing_details}'''),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    AppLocalizations.of(context)!.contact_us,
                                    style: GoogleFonts.sansita(fontSize: 20),
                                  ),
                                ),
                                Text(
                                  ''
                                  '${AppLocalizations.of(context)!.contact_details}'
                                  '',
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(AppLocalizations.of(context)!.close),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      CupertinoIcons.forward,
                      color: Colors.green,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
