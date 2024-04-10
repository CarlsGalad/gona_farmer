import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
// sign in user
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      //if wrong email
      if (e.code == 'user=not-found') {
        //show error to user
        showErrorMessage(e.code);
      }
    }
  }

  // show error snackbar
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/images/Generated.jpeg"),
                fit: BoxFit.fill,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
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
                  // welcome message
                  Text('Welcome to Gona Market place',
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
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: 'Email'),
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
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: 'Password'),
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
                          child: const Text(
                            'forgot password?',
                            style: TextStyle(
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
                    child: GestureDetector(
                      onTap: () {
                        signUserIn();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 49, 105, 11),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
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
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.white),
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
                      const Text(
                        'Dont have an account?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          '  Sign up now',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
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
    );
  }
}
