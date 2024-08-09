import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class UserCityWidget extends StatefulWidget {
  const UserCityWidget({super.key});

  @override
  UserCityWidgetState createState() => UserCityWidgetState();
}

class UserCityWidgetState extends State<UserCityWidget> {
  String _userCity = '';

  @override
  void initState() {
    super.initState();
    _fetchUserCity();
  }

  Future<void> _fetchUserCity() async {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Fetch user city from Firestore
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('farms')
              .doc(userId)
              .get();

      // Extract the city from the user data
      setState(() {
        _userCity = userSnapshot['city'] ??
            'Unknown'; // Default to 'Unknown' if city is not found
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 15),
      child: Text(
        _userCity,
        style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 17),
      ),
    );
  }
}
