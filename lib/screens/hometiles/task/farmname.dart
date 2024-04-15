import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FarmNameWidget extends StatefulWidget {
  const FarmNameWidget({super.key});

  @override
  FarmNameWidgetState createState() => FarmNameWidgetState();
}

class FarmNameWidgetState extends State<FarmNameWidget> {
  late String _farmName = '';

  @override
  void initState() {
    super.initState();
    _fetchFarmName();
  }

  Future<void> _fetchFarmName() async {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Fetch farm name from Firestore for the current user's farm
      DocumentSnapshot farmSnapshot = await FirebaseFirestore.instance
          .collection('farms')
          .doc(userId)
          .get();

      // Get the farm name from the document snapshot
      setState(() {
        _farmName = farmSnapshot['farmName'] ?? 'Farm Name Not Found';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 15),
      child: Text(
        _farmName ?? 'Loading...', // Display farm name or loading message
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }
}
