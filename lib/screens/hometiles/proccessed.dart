import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProcessedOrdersScreen extends StatefulWidget {
  const ProcessedOrdersScreen({super.key});

  @override
  ProcessedOrdersScreenState createState() => ProcessedOrdersScreenState();
}

class ProcessedOrdersScreenState extends State<ProcessedOrdersScreen> {
  late String _farmId;
  late Future<QuerySnapshot<Map<String, dynamic>>> _processedOrdersFuture;

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
      // Fetch Processed order items for the current user's farmId
      _processedOrdersFuture = FirebaseFirestore.instance
          .collection('orderItems')
          .where('farmId', isEqualTo: _farmId)
          .where('status', isEqualTo: 'prepared')
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
          AppLocalizations.of(context)!.processed_orders,
          style: GoogleFonts.aboreto(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: _processedOrdersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                  '${AppLocalizations.of(context)!.error} ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Processed orders found.'),
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
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Colors.green),
                    child: ListTile(
                      title: Text(
                        orderData['item_name'] ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Price: ${orderData['item_price'] ?? ''}',
                        style: const TextStyle(color: Colors.white),
                      ),
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
