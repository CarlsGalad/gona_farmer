import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Text('Error: User not found'));
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
              return const Center(child: Text('User data not found.'));
            }
            var farmData = snapshot.data!.data() as Map<String, dynamic>;
            var farmProfile = FarmProfile(
              email: farmData['email'],
              mobile: farmData['mobile'],
              address: farmData['address'] ?? '',
              state: farmData['state'] ?? '',
              imagePath: farmData['imagePath'] ?? '',
              city: farmData['city'] ?? '',
              farmName: '${farmData['farmName']}',
              ownersName: farmData['ownersName'],
            );

            return // address container
                Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Address',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 20),
                      ),
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.place,
                            color: Colors.green,
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
                                    'Address',
                                    style: GoogleFonts.sansita(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
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
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.location_city,
                            color: Colors.green,
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
                                    'City',
                                    style: GoogleFonts.sansita(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
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
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.map_rounded,
                            color: Colors.green,
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
                                    'State',
                                    style: GoogleFonts.sansita(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
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
              ),
            );
          },
        );
      },
    );
  }
}
