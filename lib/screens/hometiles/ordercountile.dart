import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gona_vendor/screens/order_list_screen.dart';

class OrderCountTile extends StatefulWidget {
  const OrderCountTile({super.key});

  @override
  OrderCountTileState createState() => OrderCountTileState();
}

class OrderCountTileState extends State<OrderCountTile> {
  int _orderCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchOrderCount();
  }

  Future<void> _fetchOrderCount() async {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Fetch orders from Firestore where farmId matches the current user's UID and order status is "placed"
      QuerySnapshot<Map<String, dynamic>> ordersSnapshot =
          await FirebaseFirestore.instance
              .collection('orders')
              .where('farmId', isEqualTo: userId)
              .where('status', isEqualTo: 'placed')
              .get();

      setState(() {
        _orderCount = ordersSnapshot.size; // Set the order count
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OrderListScreen(),
          ),
        );
      },
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
                  _orderCount.toString(), // Display the order count
                  style: const TextStyle(fontSize: 45),
                  textAlign: TextAlign.start,
                ),
              ),
              const Text(
                'Orders',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
