import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gona_vendor/screens/hometiles/proccessed.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final tileWidth = screenWidth - (screenWidth / 3.5) - 40;
    final tileHeight = screenHeight *
        0.17; // Adjust height based on percentage of screen height

    return SizedBox(
      width: tileWidth,
      child: FutureBuilder<List<Map<String, dynamic>>?>(
        future: _processedOrdersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                size: 30,
                color: Colors.green.shade100,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                  '${AppLocalizations.of(context)!.processed_tile_error} ${snapshot.error}'),
            );
          } else {
            int processedOrdersCount = snapshot.data?.length ?? 0;
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProcessedOrdersScreen(),
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
                    padding: EdgeInsets.only(
                        left: screenWidth *
                            0.03), // Adjust padding based on screen width
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.access_time,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: screenHeight *
                                  0.02), // Adjust top padding based on screen height
                          child: Text(
                            '$processedOrdersCount',
                            style: GoogleFonts.aboreto(
                              fontSize: screenWidth *
                                  0.1, // Adjust font size based on screen width
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.processed_orders_label,
                          style: GoogleFonts.abel(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth *
                                0.04, // Adjust font size based on screen width
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
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
