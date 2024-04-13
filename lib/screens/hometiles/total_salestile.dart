import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class TotalSalesTile extends StatefulWidget {
  const TotalSalesTile({super.key});

  @override
  TotalSalesTileState createState() => TotalSalesTileState();
}

class TotalSalesTileState extends State<TotalSalesTile> {
  int _totalSales = 0;

  @override
  void initState() {
    super.initState();
    _fetchTotalSales();
  }

  Future<void> _fetchTotalSales() async {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Fetch the 'farms' document from Firestore for the current user
      DocumentSnapshot<Map<String, dynamic>> farmSnapshot =
          await FirebaseFirestore.instance
              .collection('farms')
              .doc(userId)
              .get();

      setState(() {
        // Set the total sales count from the fetched document
        _totalSales = farmSnapshot['totalSales'] ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final numberFormatter = NumberFormat('#,###');
    return Expanded(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 137, 247, 143),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  numberFormatter
                      .format(_totalSales), // Display the total sales count
                  style: const TextStyle(fontSize: 45),
                  textAlign: TextAlign.start,
                ),
              ),
              const Text(
                'Total sales',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
