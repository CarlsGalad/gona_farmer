import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/auth_service.dart';
import 'reset_passwd.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late SharedPreferences sharedPreferences;

  //text editing controller
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
// sign user in method
  void signUserIn() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.green.shade100, size: 50));
        });

    // sign in user
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      // Get the user ID
      String userId = userCredential.user?.uid ?? '';

      // Check if user document exists in "farms" collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('farms')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        // Throw error if user not found in "farms" collection
        throw FirebaseAuthException(
            code: 'user-not-found-in-farms',
            message: 'User not found in farms collection');
      }

      if (!mounted) return;

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      // Show error message based on the error code
      showErrorMessage(e.message ?? 'An error occurred');
    }
  }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/images/singinbg.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.white.withOpacity(0.4)),
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),

                    // app logo
                    Center(
                      child: Image.asset(
                        'lib/images/logo_plain.png',
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
                            text: 'Vendors',
                            style: GoogleFonts.abel(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      textAlign:
                          TextAlign.center, // Optional: Center-align the text
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // welcome message
                    Center(
                      child: Text(
                        "Welcome Back",
                        style: GoogleFonts.abel(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    //Email textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Card(
                        elevation: 2,
                        color: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                          side: const BorderSide(color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    AppLocalizations.of(context)!.emailHint),
                            autofillHints: const [
                              AutofillHints.email,
                            ],
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    //Password textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Card(
                        elevation: 2,
                        color: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                          side: const BorderSide(color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    AppLocalizations.of(context)!.passwordHint),
                            autofillHints: const [AutofillHints.password],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),

                    // forgot password text button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const ResetPassWPage();
                              }));
                            },
                            child: Text(
                              AppLocalizations.of(context)!.forgotPassword,
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),

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
                          signUserIn();
                        },
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.signIn,
                            style: const TextStyle(
                                color: Colors.white,
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
                      height: 20,
                    ),

                    // google sign in
                    Center(
                      child: MaterialButton(
                        padding: EdgeInsets.all(5),
                        elevation: 2,
                        color: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                          side: const BorderSide(color: Colors.white),
                        ),
                        onPressed: () => AuthService().signInWithGoogle(),
                        child: Image.asset(
                          'lib/images/g_icon.png',
                          height: 35,
                          width: 35,
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
                          AppLocalizations.of(context)!.dontHaveAccount,
                          style: GoogleFonts.abel(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            AppLocalizations.of(context)!.signUpNow,
                            style: GoogleFonts.abel(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(),
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
