import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class TotalEarningsDisplay extends StatelessWidget {
  const TotalEarningsDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 15),
      child: Container(
        width: MediaQuery.of(context).size.width - 30,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 137, 247, 143),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FutureBuilder<DocumentSnapshot>(
          future: _fetchTotalEarnings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              int totalEarnings = snapshot.data?['totalEarnings'] ??
                  0; // Retrieve total earnings
              String formattedTotalEarnings =
                  _formatNumber(totalEarnings); // Format total earnings
              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        '₦$formattedTotalEarnings',
                        style: const TextStyle(fontSize: 45),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: Text(
                        'Total Earnings',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<DocumentSnapshot> _fetchTotalEarnings() async {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Fetch the farms document from Firestore
      return await FirebaseFirestore.instance
          .collection('farms')
          .doc(userId)
          .get();
    } else {
      // Return a default DocumentSnapshot if the user is not logged in
      return FirebaseFirestore.instance.doc('farms/default').get();
    }
  }

  String _formatNumber(int number) {
    // Use NumberFormat to format the number with commas
    return NumberFormat('#,##0').format(number);
  }
}
