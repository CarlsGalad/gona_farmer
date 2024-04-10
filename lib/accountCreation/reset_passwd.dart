import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ResetPassWPage extends StatefulWidget {
  const ResetPassWPage({super.key});

  @override
  State<ResetPassWPage> createState() => _ResetPassWPageState();
}

class _ResetPassWPageState extends State<ResetPassWPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Reset Link set! Check you email'),
            );
          });
    } on FirebaseException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            'Enter your Email to recieve password reset link',
            textAlign: TextAlign.center,
          ),
        ),
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
                controller: _emailController,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Email'),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        MaterialButton(
          onPressed: () {},
          color: const Color.fromARGB(255, 49, 105, 11),
          child: const Text('Reset Password'),
        )
      ],
    ));
  }
}
