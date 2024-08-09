import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gona_vendor/screens/orders/order_detail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            CupertinoIcons.back,
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.ordered_items,
          style: GoogleFonts.aboreto(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  size: 50, color: Colors.green.shade100),
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text('${AppLocalizations.of(context)!.error} '
                    '${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  color: Colors.grey,
                ),
                Text('No new Orders'),
              ],
            ));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> order = snapshot.data![index];
                // Convert timestamp to DateTime object
                DateTime orderDate =
                    (order['order_date'] as Timestamp).toDate();
                // Format the DateTime object
                String formattedDate =
                    DateFormat('yyyy-MM-dd HH:mm').format(orderDate);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ItemDetailPage(orderId: order['order_id'])));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 4),
                    child: Card(
                      elevation: 5,
                      color: Colors.green.shade100,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${AppLocalizations.of(context)!.order_id} '
                              ' ${order['order_id']}',
                              style: GoogleFonts.sansita(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, bottom: 8),
                            child: Text(
                              '${AppLocalizations.of(context)!.order_date} $formattedDate',
                              style: GoogleFonts.abel(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ), // Display formatted date
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchOrders() async {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Fetch orders from Firestore where farmId matches the current user's UID
      QuerySnapshot<Map<String, dynamic>> orderItemsSnapshot =
          await FirebaseFirestore.instance
              .collection('orderItems')
              .where('farmId', isEqualTo: userId)
              .where('status', isEqualTo: 'placed')
              .get();

      // Extract and return the list of order items
      return orderItemsSnapshot.docs.map((doc) => doc.data()).toList();
    } else {
      // Return an empty list if the user is not logged in
      return [];
    }
  }
}
