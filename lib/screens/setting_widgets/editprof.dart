import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'edit_profile_screen.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8),
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
                  Icons.person_2_rounded,
                  color: Colors.green,
                ),
              ),
              Text(
                'Edit Profile',
                style: GoogleFonts.sansita(fontSize: 18),
              ),
              const Spacer(),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfileScreen()),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(CupertinoIcons.forward, color: Colors.green),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
