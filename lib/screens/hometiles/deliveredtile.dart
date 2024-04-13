import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeliveredCountTile extends StatefulWidget {
  const DeliveredCountTile({super.key});

  @override
  DeliveredCountTileState createState() => DeliveredCountTileState();
}

class DeliveredCountTileState extends State<DeliveredCountTile> {
  int _deliveredCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchDeliveredCount();
  }

  Future<void> _fetchDeliveredCount() async {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Fetch order items from Firestore where farmId matches the current user's UID and status is "delivered"
      QuerySnapshot<Map<String, dynamic>> deliveredOrderItemsSnapshot =
          await FirebaseFirestore.instance
              .collection('orderItems')
              .where('farmId', isEqualTo: userId)
              .where('status', isEqualTo: 'delivered')
              .get();

      setState(() {
        _deliveredCount =
            deliveredOrderItemsSnapshot.size; // Set the delivered count
      });

      // Increment totalSales in the farms collection
      await _incrementTotalSales(_deliveredCount);

      // Update totalEarnings in the farms collection
      await _updateTotalEarnings(deliveredOrderItemsSnapshot.docs);
    }
  }

  Future<void> _incrementTotalSales(int incrementBy) async {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Increment totalSales by the provided value
      await FirebaseFirestore.instance.collection('farms').doc(userId).update({
        'totalSales': FieldValue.increment(incrementBy),
      });
    }
  }

  Future<void> _updateTotalEarnings(List<DocumentSnapshot> orderItems) async {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Calculate total earnings from order items
      int totalEarnings = orderItems.fold(0, (sum, orderItem) {
        //The price field is cast to an integer before adding
        return sum + (orderItem['price'] as int? ?? 0);
      });

      // Update totalEarnings in the farms collection
      await FirebaseFirestore.instance.collection('farms').doc(userId).update({
        'totalEarnings': FieldValue.increment(totalEarnings),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
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
                  _deliveredCount.toString(), // Display the delivered count
                  style: const TextStyle(fontSize: 45),
                  textAlign: TextAlign.start,
                ),
              ),
              const Text(
                'Delivered',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
