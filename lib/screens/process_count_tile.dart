import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProcessedTile extends StatefulWidget {
  const ProcessedTile({super.key});

  @override
  State<ProcessedTile> createState() => _ProcessedTileState();
}

class _ProcessedTileState extends State<ProcessedTile> {
  late Future<List<Map<String, dynamic>>?> _processedOrdersFuture;

  @override
  void initState() {
    super.initState();
    _processedOrdersFuture = _fetchProcessedOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Map<String, dynamic>>?>(
        future: _processedOrdersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            int processedOrdersCount = snapshot.data?.length ?? 0;
            return Container(
              width: 240,
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
                        '$processedOrdersCount',
                        style: const TextStyle(fontSize: 45),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const Text(
                      "Processed Order's",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>?> _fetchProcessedOrders() async {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Fetch processed orders from Firestore where farmId matches the current user's UID and status is "prepared"
      QuerySnapshot<Map<String, dynamic>> processedOrdersSnapshot =
          await FirebaseFirestore.instance
              .collection('orderItems')
              .where('farmId', isEqualTo: userId)
              .where('status', isEqualTo: 'prepared')
              .get();

      // Extract and return the list of processed order items
      return processedOrdersSnapshot.docs.map((doc) => doc.data()).toList();
    } else {
      // Return null if the user is not logged in
      return null;
    }
  }
}
