import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomeBackWidget extends StatefulWidget {
  const WelcomeBackWidget({super.key});

  @override
  WelcomeBackWidgetState createState() => WelcomeBackWidgetState();
}

class WelcomeBackWidgetState extends State<WelcomeBackWidget> {
  String _farmerName = '';

  @override
  void initState() {
    super.initState();
    _fetchFarmerName();
  }

  Future<void> _fetchFarmerName() async {
    // Get the current user's UID from Firebase Authentication
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      // Fetch the farmer's name from the Firestore collection using the UID
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('farms').doc(uid).get();
      if (snapshot.exists) {
        setState(() {
          _farmerName = snapshot['ownersName'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 30.0, left: 30, right: 30, bottom: 10),
        child: Text(
          _farmerName.isNotEmpty
              ? 'Welcome back ${_farmerName.split(' ').first}'
              : 'Welcome back',
          style: const TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
