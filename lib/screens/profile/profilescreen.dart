import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/usermodel.dart';
import 'profile_widgets/account_info.dart';
import 'profile_widgets/address_info.dart';

import 'profile_widgets/personal_info.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late File _imageFile;

  Future<void> _uploadImage(User user) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('farms_profile_images')
            .child('${user.uid}.jpg');
        await ref.putFile(_imageFile);
        final imageUrl = await ref.getDownloadURL();

        // Update the user's profile with the new image URL
        await FirebaseFirestore.instance
            .collection('farms')
            .doc(user.uid)
            .update({'imagePath': imageUrl});
      } catch (e) {
        rethrow;

        // Handle the error
      }
    }
  }

  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

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
          AppLocalizations.of(context)!.profile,
          style: GoogleFonts.aboreto(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(
                child: Column(
              children: [
                Text(AppLocalizations.of(context)!.userNotFound),
                GestureDetector(
                    onTap: () {},
                    child: Text(AppLocalizations.of(context)!.signIn))
              ],
            ));
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
                    child: Text(
                        AppLocalizations.of(context)!.user_data_not_found));
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
                ownersName: '${farmData['ownersName']}',
              );

              // starts here
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      height: 1000,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("lib/images/Generated.jpeg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 150,
                            bottom: 0,
                            child: Container(
                              height: MediaQuery.of(context).size.height - 250,
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 80,
                                  ),
                                  // current user name
                                  Center(
                                    child: Text(
                                      farmProfile.farmName
                                          .split(' ')
                                          .map((word) => word.isNotEmpty
                                              ? '${word[0].toUpperCase()}${word.substring(1)}'
                                              : '')
                                          .join(' '),
                                      style: GoogleFonts.sansita(fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),

                                  const PersonalInfo(),

                                  const AddressInfo(),
                                  AccountDetailWidget(
                                    farmId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromRGBO(
                                                184, 181, 181, 1),
                                            offset: Offset(2, 2),
                                            blurRadius: 4.0,
                                            spreadRadius: 1.0,
                                            blurStyle: BlurStyle.normal,
                                          ),
                                          BoxShadow(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 0.9),
                                            offset: Offset(-0, -1),
                                            blurRadius: 5.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.green.shade300),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          signUserOut();
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.logout,
                                                color: Colors.red,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text('Log out')
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 70,
                            right: 100,
                            left: 100,
                            child: CircleAvatar(
                              radius: 70,
                              child: Container(
                                height: 135,
                                width: 135,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(
                                      color: Colors.green.shade300, width: 2),
                                  borderRadius: BorderRadius.circular(90),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(90),
                                  child: farmProfile.imagePath.isNotEmpty
                                      ? Image.network(farmProfile.imagePath)
                                      : const Icon(
                                          Icons.person,
                                          size: 130,
                                          color: Colors.grey,
                                        ),
                                ), // Placeholder for no image )
                              ),
                            ),
                          ),
                          Positioned(
                            top: 185,
                            right: 100,
                            left: 100,
                            child: GestureDetector(
                              onTap: () => _uploadImage(user),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.green.shade300,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.circular(360),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
