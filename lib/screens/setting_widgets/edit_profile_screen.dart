import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/helper/statesandlg.dart';

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

  String? selectedState;
  String? selectedLga;
  @override
  void initState() {
    super.initState();

    // Fetch current user's information from Firebase Auth
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Populate the initial fields with user data
      _emailController.text = user.email ?? '';

      // Fetch additional user details from Firestore
      FirebaseFirestore.instance
          .collection('farms') // The collection where user data is stored
          .doc(user.uid) // The document ID is the user's UID
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            _farmNameController.text = documentSnapshot['farmName'] ?? '';
            _ownersNameController.text = documentSnapshot['ownersName'] ?? '';
            _mobileController.text = documentSnapshot['mobile'] ?? '';
            _addressController.text = documentSnapshot['address'] ?? '';
            selectedState = documentSnapshot['state'];
            selectedLga = documentSnapshot['lga'];
          });
        }
      }).catchError((error) {
        // Handle any errors here
        print("Error fetching user data: $error");
      });
    }
  }

  void _submitChanges() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      //TODO: add custom email action handler
      // Update update email address
      user.verifyBeforeUpdateEmail(
        _emailController.text,
      );

      // Update user profile in Firestore
      FirebaseFirestore.instance.collection('farms').doc(user.uid).update({
        'farmName': _farmNameController.text,
        'ownersName': _ownersNameController.text,
        'email': _emailController.text,
        'moblle': _mobileController,
        'address': _addressController.text,
        'lga': selectedLga,
        'state': selectedState,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.grey.shade200,
                    elevation: 2,
                    shape: const BeveledRectangleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _farmNameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: AppLocalizations.of(context)!.farm_name,
                          labelStyle: GoogleFonts.sansita(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Last name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.grey.shade200,
                    elevation: 2,
                    shape: const BeveledRectangleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _ownersNameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: AppLocalizations.of(context)!.farm_owner,
                          labelStyle: GoogleFonts.sansita(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //edit email field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.grey.shade200,
                    elevation: 2,
                    shape: const BeveledRectangleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText:
                              AppLocalizations.of(context)!.email_address,
                          labelStyle: GoogleFonts.sansita(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.grey.shade200,
                    elevation: 2,
                    shape: const BeveledRectangleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _mobileController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixText: '+234',
                          hintText: '80 62 XXX XXX',
                          labelText: AppLocalizations.of(context)!.phone_hint,
                          labelStyle: GoogleFonts.sansita(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.grey.shade200,
                    elevation: 2,
                    shape: const BeveledRectangleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: AppLocalizations.of(context)!.address,
                          labelStyle: GoogleFonts.sansita(),
                        ),
                        keyboardType: TextInputType.streetAddress,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      // State dropdown with search
                      Expanded(
                        child: Card(
                          color: Colors.grey.shade200,
                          elevation: 2,
                          shape: const BeveledRectangleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 15.0, right: 10),
                            child: DropdownSearch<String>(
                              items: statesAndLgas.keys.toList(),
                              selectedItem: selectedState,
                              onChanged: (value) {
                                setState(() {
                                  selectedState = value;
                                  selectedLga =
                                      null; // Reset LGA when state changes
                                });
                              },
                              popupProps: PopupProps.menu(
                                  showSelectedItems: true,
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                          fillColor: Colors.grey[300],
                                          border: InputBorder.none,
                                          filled: true))),
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  hintText: "Select State",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // LGA dropdown with search
                      Expanded(
                        child: Card(
                          color: Colors.grey.shade200,
                          elevation: 2,
                          shape: const BeveledRectangleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 15, right: 10.0),
                            child: DropdownSearch<String>(
                              items: selectedState == null
                                  ? []
                                  : statesAndLgas[selectedState!]!,
                              selectedItem: selectedLga,
                              onChanged: (value) {
                                setState(() {
                                  selectedLga = value;
                                });
                              },
                              popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                          fillColor: Colors.grey[300],
                                          border: InputBorder.none,
                                          filled: true))),
                              // ignore: prefer_const_constructors
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  hintText: "Select LGA",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 35,
                ),

                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: Colors.green.shade100,
                  elevation: 18,
                  onPressed: () {
                    _submitChanges();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.update_profile,
                        style: GoogleFonts.sansita(fontSize: 18),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.save,
                      )
                    ],
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
