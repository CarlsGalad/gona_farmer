import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../models/usermodel.dart';

class AddressInfo extends StatefulWidget {
  const AddressInfo({super.key});

  @override
  State<AddressInfo> createState() => _AddressInfoState();
}

class _AddressInfoState extends State<AddressInfo> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.green.shade100, size: 50));
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
              return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.green.shade100, size: 50));
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
              mobile: farmData['mobile'],
              address: farmData['address'] ?? '',
              state: farmData['state'] ?? '',
              imagePath: farmData['imagePath'] ?? '',
              city: farmData['lga'] ?? '',
              farmName: '${farmData['farmName']}',
              ownersName: farmData['ownersName'],
            );

            return // address container
                Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.address,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.place,
                          color: Colors.green.shade300,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 270,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.address,
                                  style: GoogleFonts.sansita(
                                    fontSize: 17.0,
                                  ),
                                ),
                                Text(
                                  farmProfile.address,
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.location_city,
                          color: Colors.green.shade300,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 270,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.city,
                                  style: GoogleFonts.sansita(
                                    fontSize: 17.0,
                                  ),
                                ),
                                Text(
                                  farmProfile.city,
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),

                  //state
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.map_rounded,
                          color: Colors.green.shade300,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 270,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.state,
                                  style: GoogleFonts.sansita(
                                    fontSize: 17.0,
                                  ),
                                ),
                                Text(
                                  farmProfile.state,
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
