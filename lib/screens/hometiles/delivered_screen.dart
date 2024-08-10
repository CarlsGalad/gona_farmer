import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DeliveredOrdersScreen extends StatefulWidget {
  const DeliveredOrdersScreen({super.key});

  @override
  DeliveredOrdersScreenState createState() => DeliveredOrdersScreenState();
}

class DeliveredOrdersScreenState extends State<DeliveredOrdersScreen> {
  late String _farmId;
  late Future<QuerySnapshot<Map<String, dynamic>>> _deliveredOrdersFuture;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserFarmId();
  }

  Future<void> _fetchCurrentUserFarmId() async {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      setState(() {
        _farmId = userId;
      });
      // Fetch delivered order items for the current user's farmId
      _deliveredOrdersFuture = FirebaseFirestore.instance
          .collection('orderItems')
          .where('farmId', isEqualTo: _farmId)
          .where('status', isEqualTo: 'delivered')
          .get();
    }
  }

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
          AppLocalizations.of(context)!.delivered_items,
          style: GoogleFonts.aboreto(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: _deliveredOrdersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  size: 50, color: Colors.green.shade100),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                  '${AppLocalizations.of(context)!.error} ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child:
                  Text(AppLocalizations.of(context)!.no_delivered_orders_found),
            );
          } else {
            // Display delivered order items
            return ListView(
              children: snapshot.data!.docs.map((document) {
                Map<String, dynamic> orderData =
                    // ignore: unnecessary_cast
                    document.data() as Map<String, dynamic>;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: Card(
                    elevation: 5,
                    color: Colors.green.shade100,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: ListTile(
                      title: Text(
                        orderData['item_mame'] ?? '',
                        style: GoogleFonts.abel(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${AppLocalizations.of(context)!.price_with_column} '
                        ' ${orderData['item_price'] ?? ''}',
                        style: GoogleFonts.abel(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      // Add more details as needed
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
