import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gona_vendor/screens/orders/order_list_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final tileWidth = MediaQuery.of(context).size.width / 3.5;
    final screenHeight = MediaQuery.of(context).size.height;

    final tileHeight = screenHeight * 0.17;

    return SizedBox(
      width: tileWidth,
      child: FutureBuilder<List<Map<String, dynamic>>?>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    size: 30, color: Colors.green.shade100));
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
              child: Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: SizedBox(
                  height: tileHeight,
                  width: tileWidth,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.notification_important,
                                color: Colors.red,
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.02),
                          child: Text(
                            '$ordersCount', // Display the order count
                            style: GoogleFonts.aboreto(
                              fontSize: screenWidth *
                                  0.1, // Adjust font size based on screen width
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.orders_label,
                          style: GoogleFonts.abel(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
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
