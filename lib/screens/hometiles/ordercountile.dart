import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gona_vendor/screens/orders/order_list_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderCountTile extends StatefulWidget {
  const OrderCountTile({super.key});

  @override
  OrderCountTileState createState() => OrderCountTileState();
}

class OrderCountTileState extends State<OrderCountTile> {
  late Future<List<Map<String, dynamic>>?> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _fetchOrderCount();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: _ordersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null) {
          return Center(
              child:
                  Text(AppLocalizations.of(context)!.order_count_tile_error));
        } else {
          int ordersCount = snapshot.data!.length;
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
                  border: Border.all(
                    color: const Color.fromARGB(255, 39, 78, 40),
                  ),
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255, 39, 78, 40),
                    Color.fromARGB(255, 101, 128, 57),
                    Color.fromARGB(255, 224, 240, 87),
                  ])),
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        '$ordersCount', // Display the order count
                        style: const TextStyle(fontSize: 45),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.orders_label,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>?> _fetchOrderCount() async {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Fetch orders from Firestore where farmId matches the current user's UID and order status is "placed"
      QuerySnapshot<Map<String, dynamic>> ordersSnapshot =
          await FirebaseFirestore.instance
              .collection('orderItems')
              .where('farmId', isEqualTo: userId)
              .where('status', isEqualTo: 'placed')
              .get();
      // Extract and return the list of processed order items
      return ordersSnapshot.docs.map((doc) => doc.data()).toList();
    } else {
      return null;
    }
  }
}
