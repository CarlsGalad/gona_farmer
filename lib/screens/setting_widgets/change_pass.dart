import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'change_pass_dialog.dart';



class ChangePass extends StatelessWidget {
  const ChangePass({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 16, right: 16, top: 4),
      child: Container(
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
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.password,
                  color: Colors.green,
                  size: 18,
                ),
              ),
              Text(
                'Change Password',
                style: GoogleFonts.sansita(fontSize: 18),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const ChangePasswordDialog(),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    CupertinoIcons.forward,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
