import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../accountCreation/signin_or_register.dart';
import 'sellang.dart';

class Changelang extends StatefulWidget {
  const Changelang({super.key});

  @override
  State<Changelang> createState() => _ChangelangState();
}

class _ChangelangState extends State<Changelang> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset('lib/images/logo_plain.png', height: 100), // App Logo
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
            textAlign: TextAlign.center, // Optional: Center-align the text
          ),
          const SizedBox(height: 80),
          Text(
            'Please select your preferred language, default is set to english.',
            style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          // select language

          const Lang(),
          const SizedBox(height: 100),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: MaterialButton(
              padding: const EdgeInsets.only(bottom: 20, right: 20),
              elevation: 18,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SigninOrRegisterPage()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Next',
                    style: GoogleFonts.abel(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 40,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
