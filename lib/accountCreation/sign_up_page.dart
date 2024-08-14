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
              image: AssetImage("lib/images/singupbg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),

                    // app logo
                    Center(
                      child: Image.asset(
                        'lib/images/logo_plain.png',
                        fit: BoxFit.cover,
                        height: 120,
                      ),
                    ),

                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Gona Market Africa \n',
                            style: GoogleFonts.agbalumo(
                                fontSize: 28.0, fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: 'Vendor',
                            style: GoogleFonts.abel(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      textAlign:
                          TextAlign.center, // Optional: Center-align the text
                    ),
                    Text(
                      AppLocalizations.of(context)!.sign_up_title,
                      style: GoogleFonts.abel(
                          fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    //Email textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Card(
                        elevation: 2,
                        color: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                          side: const BorderSide(color: Colors.white),
                        ),
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
                      height: 8,
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          // farm name field
                          Expanded(
                            child: Card(
                              elevation: 2,
                              color: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                                side: const BorderSide(color: Colors.white),
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
                            width: 8,
                          ),
                          // farm owners name
                          Expanded(
                            child: Card(
                              elevation: 2,
                              color: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                                side: const BorderSide(color: Colors.white),
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

                    const SizedBox(height: 8.0),

                    // Phone number filed
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Card(
                        elevation: 2,
                        color: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                          side: const BorderSide(color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            controller: mobileController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  AppLocalizations.of(context)!.phone_hint,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    // Farm address filed
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Card(
                        elevation: 2,
                        color: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                          side: const BorderSide(color: Colors.white),
                        ),
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

                    const SizedBox(height: 8.0),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          // State dropdown with search
                          Expanded(
                            child: Card(
                              elevation: 2,
                              color: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                                side: const BorderSide(color: Colors.white),
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
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      hintText: "Select State",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // LGA dropdown with search
                          Expanded(
                            child: Card(
                              elevation: 2,
                              color: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                                side: const BorderSide(color: Colors.white),
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
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
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

                    const SizedBox(height: 8.0),

                    //Password textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Card(
                        elevation: 2,
                        color: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                          side: const BorderSide(color: Colors.white),
                        ),
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
                    const SizedBox(height: 8.0),
                    // confirm Password textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Card(
                        elevation: 2,
                        color: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                          side: const BorderSide(color: Colors.white),
                        ),
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
                            borderRadius: BorderRadius.circular(5)),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              AppLocalizations.of(context)!.orContinueWith,
                              style: GoogleFonts.abel(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
                    MaterialButton(
                      padding: EdgeInsets.all(5),
                      elevation: 2,
                      color: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.white),
                      ),
                      onPressed: () => AuthService().signInWithGoogle(),
                      child: Image.asset(
                        'lib/images/g_icon.png',
                        height: 35,
                        width: 35,
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
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            AppLocalizations.of(context)!.sign_in_now,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
