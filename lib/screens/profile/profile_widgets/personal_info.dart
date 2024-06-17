import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../models/usermodel.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data == null) {
          return Center(
              child: Text(AppLocalizations.of(context)!.error_user_not_found));
        }
        var user = snapshot.data!;
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('farms')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(
                  child:
                      Text(AppLocalizations.of(context)!.user_data_not_found));
            }
            var farmData = snapshot.data!.data() as Map<String, dynamic>;
            var farmProfile = FarmProfile(
              email: farmData['email'],
              mobile: farmData['mobile'] ?? '',
              address: farmData['address'] ?? '',
              state: farmData['state'] ?? '',
              imagePath: farmData['imagePath'] ?? '',
              city: farmData['city'] ?? '',
              farmName: '${farmData['farmName']}',
              ownersName: '${farmData['ownersName']}',
            );

            return Padding(
              padding: const EdgeInsets.all(16.0),
              // personal info starts here container
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
                    border: Border.all(color: Colors.green)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //person info Text
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!.personal_info,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 20),
                      ),
                    ),

                    // row containing email and phone number
                    Row(
                      children: [
                        //email row with icon
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 6),
                                      child: Icon(
                                        Icons.mail,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.email,
                                          style: GoogleFonts.sansita(
                                            fontSize: 17,
                                          ),
                                        ),
                                        Text(farmProfile.email),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
//phone number container
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.call,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            AppLocalizations.of(context)!
                                                .phone_number,
                                            style: GoogleFonts.sansita(
                                              fontSize: 17,
                                            )),
                                        Text(farmProfile.mobile),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // owerners name
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            AppLocalizations.of(context)!
                                                .farm_owner,
                                            style: GoogleFonts.sansita(
                                              fontSize: 17,
                                            )),
                                        Text(farmProfile.ownersName),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
