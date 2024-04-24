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
  const SettingsPrivacyPage({super.key});

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
          style: GoogleFonts.bebasNeue(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Account Settings',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            ),
            const Divider(
              indent: 30,
              endIndent: 30,
            ),
            Container(
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
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Privacy Settings',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            ),
            const Divider(
              indent: 30,
              endIndent: 30,
            ),
            Container(
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
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Other Settings',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(
                    indent: 30,
                    endIndent: 30,
                  ),

                  // select language
                  const SelectLang(),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16, bottom: 16),
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
                      child: ListTile(
                        leading: CupertinoSwitch(
                          value: false,
                          onChanged: (bool value) {},
                        ),
                        title: Text('Themes',
                            style: GoogleFonts.sansita(fontSize: 18)),
                        onTap: () {
                          // Navigate to Theme Settings screen
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
