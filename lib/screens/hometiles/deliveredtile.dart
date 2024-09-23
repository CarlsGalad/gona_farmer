import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gona_vendor/screens/hometiles/delivered_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

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
      // ignore: avoid_types_as_parameter_names
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final tileWidth = screenWidth - (screenWidth / 3.5) - 40;
    final tileHeight = screenHeight * 0.17;

    return SizedBox(
      width: tileWidth,
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DeliveredOrdersScreen(),
          ),
        ),
        child: Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: SizedBox(
            width: tileWidth,
            height: tileHeight,
            child: Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.03, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.handshake,
                          color: Colors.green,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: Text(
                      _deliveredCount.toString(), // Display the delivered count
                      style: GoogleFonts.aboreto(
                        fontSize: screenWidth * 0.1,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.delivered_label,
                    style: GoogleFonts.abel(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
