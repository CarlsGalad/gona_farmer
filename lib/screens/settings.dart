import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'setting_widgets/change_pass.dart';
import 'setting_widgets/editprof.dart';
import 'setting_widgets/managenotifi.dart';
import 'setting_widgets/policy.dart';
import 'setting_widgets/selected_lang.dart';
import 'setting_widgets/service_terms.dart';

class SettingsPrivacyPage extends StatelessWidget {
  const SettingsPrivacyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.back),
        ),
        title: Text(
          'Settings & Privacy',
          style: GoogleFonts.aboreto(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Account Settings',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Divider(
                  indent: 30,
                  endIndent: 30,
                ),
                EditProfile(),
                ChangePass(),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Privacy Settings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  indent: 30,
                  endIndent: 30,
                ),
                Policy(),
                ServiceTerms(),
                NotificationSetting(),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Other Settings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  indent: 30,
                  endIndent: 30,
                ),

                // select language
                SelectLang(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
