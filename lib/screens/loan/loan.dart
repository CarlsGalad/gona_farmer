import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Loan extends StatelessWidget {
  const Loan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Finance',
          style: GoogleFonts.aboreto(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Coming soon'),
      ),
    );
  }
}
