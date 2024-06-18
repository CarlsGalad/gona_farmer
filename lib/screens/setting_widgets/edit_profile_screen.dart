import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _farmNameController = TextEditingController();
  final _ownersNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch current user's information from Firebase Auth
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String displayName = user.displayName ?? '';
      List<String> nameParts = displayName.split(' ');
      _farmNameController.text = nameParts.isNotEmpty ? nameParts[0] : '';
      _ownersNameController.text = nameParts.length > 1 ? nameParts[1] : '';
      _emailController.text = user.email ?? '';
    }
  }

  void _submitChanges() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      //TODO: add custom email action handler
      // Update update email address
      user.verifyBeforeUpdateEmail(_emailController.text);

      // Update user profile in Firestore
      FirebaseFirestore.instance.collection('farms').doc(user.uid).update({
        'farmName': _farmNameController.text,
        'ownersName': _ownersNameController.text,
        'email': _emailController.text,
        'moblle': _mobileController,
        'address': _addressController,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context)!.profile_updated_successfully)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.back)),
        title: Text(
          AppLocalizations.of(context)!.update_profile,
          style: GoogleFonts.aboreto(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _farmNameController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.farm_name,
                        labelStyle: GoogleFonts.sansita(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Last name
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _ownersNameController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.farm_owner,
                        labelStyle: GoogleFonts.sansita(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //edit email field
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.email_address,
                        labelStyle: GoogleFonts.sansita(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _mobileController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.email_address,
                        labelStyle: GoogleFonts.sansita(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.address,
                        labelStyle: GoogleFonts.sansita(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 35,
                ),

                GestureDetector(
                  onTap: () {
                    _submitChanges();
                  },
                  child: Center(
                    child: Container(
                      width: 200,
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
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.update_profile,
                              style: GoogleFonts.sansita(color: Colors.white),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.save,
                              color: Colors.white,
                            )
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
      ),
    );
  }
}
