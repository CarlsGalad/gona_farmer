import 'package:flutter/material.dart';

import 'sign_up_page.dart';
import 'signinscreen.dart';

class SigninOrRegisterPage extends StatefulWidget {
  const SigninOrRegisterPage({super.key});

  @override
  State<SigninOrRegisterPage> createState() => _SigninOrRegisterPageState();
}

class _SigninOrRegisterPageState extends State<SigninOrRegisterPage> {
  // show sign in screen on start

  bool showSigninPage = true;

  void togglePages() {
    setState(() {
      showSigninPage = !showSigninPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSigninPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return SingUpPage(
        onTap: togglePages,
      );
    }
  }
}
