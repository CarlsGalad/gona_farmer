import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gona_vendor/models/helper/statesandlg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../services/auth_service.dart';

class SingUpPage extends StatefulWidget {
  final Function()? onTap;

  const SingUpPage({super.key, required this.onTap});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  //text editing controller
  final emailController = TextEditingController();
  final ownerNameController = TextEditingController();

  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final townController = TextEditingController();
  final farmNameController = TextEditingController();
  String? selectedState;
  String? selectedLga;

// sign user up method
  void signUserUp() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.green.shade100, size: 50),
          );
        });
// Create new user
    try {
      //check if password correponds
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        // Save user details to Firestore
        saveUserDetailsToFirestore();
      } else {
        // show error message, passwords dont't match
        showErrorMessage(AppLocalizations.of(context)!.passwords_dont_match);
      }
      if (!mounted) {
        return;
      }
      //pop the progress indicator
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop progress indicator
      Navigator.pop(context);
      //if wrong email
      if (e.code == AppLocalizations.of(context)!.userNotFound) {
        // Show error to user
        showErrorMessage(
            e.message ?? AppLocalizations.of(context)!.sign_up_failed);
      }
    }
  }

  // Save user details to Firestore
  void saveUserDetailsToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Access Firestore instance
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Save user details to Firestore
        await firestore.collection('farms').doc(user.uid).set({
          'email': emailController.text,
          'ownersName': ownerNameController.text,
          'mobile': mobileController.text,
          'address': addressController.text,
          'state': selectedState,
          'lga': selectedLga,
          'farmName': farmNameController.text,
          'userId': user.uid,
          'createdAt': Timestamp.now(),
          'accountDetails': {
            'accountName': '',
            'bankName': '',
            'accountNumber': '',
          },
          'totalSales': '',
          'totalEarnings': '',
        });
        if (!mounted) return;
        // Pop the progress indicator
        Navigator.pop(context);
      } catch (e) {
        // Pop the progress indicator
        Navigator.pop(context);
        // Show error message
        showErrorMessage(AppLocalizations.of(context)!.save_details_failed);
      }
    }
  }

  // show error snackbar
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/images/Generated.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),

                  // app logo
                  Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(30)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          'lib/images/Gona logo.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(AppLocalizations.of(context)!.sign_up_title,
                      style: GoogleFonts.bebasNeue(
                          fontSize: 30, color: Colors.white)),
                  const SizedBox(
                    height: 10,
                  ),

                  //Email textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  AppLocalizations.of(context)!.emailHint),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        // farm name field
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextField(
                                controller: farmNameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: AppLocalizations.of(context)!
                                      .farm_name_hint,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        // farm owners name
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextField(
                                controller: ownerNameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: AppLocalizations.of(context)!
                                      .owner_name_hint,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15.0),

                  // Phone number filed
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          controller: mobileController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(context)!.phone_hint,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),

                  // Farm address filed
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          keyboardType: TextInputType.streetAddress,
                          controller: addressController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  AppLocalizations.of(context)!.address_hint),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15.0),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        // State dropdown with search
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
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
                                  dropdownSearchDecoration:
                                      const InputDecoration(
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

                  const SizedBox(height: 15.0),

                  //Password textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  AppLocalizations.of(context)!.passwordHint),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  // confirm Password textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context)!
                                  .confirm_password_hint),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),

                  const SizedBox(height: 15.0),

                  //sign in button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: MaterialButton(
                      elevation: 18,
                      color: Colors.green.shade100,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () {
                        signUserUp();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80.0, vertical: 20),
                        child: Text(
                          AppLocalizations.of(context)!.sign_up_button,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey[400],
                            thickness: 0.6,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            AppLocalizations.of(context)!.orContinueWith,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey[400],
                            thickness: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // google sign in
                  GestureDetector(
                    onTap: () => AuthService().signInWithGoogle(),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Image.asset(
                          'lib/images/g_icon.png',
                          height: 65,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.already_have_account,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          AppLocalizations.of(context)!.sign_in_now,
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
