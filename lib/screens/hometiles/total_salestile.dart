import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TotalSalesTile extends StatefulWidget {
  const TotalSalesTile({super.key});

  @override
  TotalSalesTileState createState() => TotalSalesTileState();
}

class TotalSalesTileState extends State<TotalSalesTile> {
  int _totalSales = 0;

  @override
  void initState() {
    super.initState();
    _fetchTotalSales();
  }

  Future<void> _fetchTotalSales() async {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Fetch the 'farms' document from Firestore for the current user
      DocumentSnapshot<Map<String, dynamic>> farmSnapshot =
          await FirebaseFirestore.instance
              .collection('farms')
              .doc(userId)
              .get();

      setState(() {
        // Set the total sales count from the fetched document
        _totalSales = farmSnapshot['totalSales'] ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tileWidth = MediaQuery.of(context).size.width / 3.5;
    final screenHeight = MediaQuery.of(context).size.height;
    final tileHeight = screenHeight * 0.17;

    final numberFormatter = NumberFormat('#,###');

    return SizedBox(
      width: tileWidth,
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: SizedBox(
          width: tileWidth,
          height: tileHeight,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                    child: Icon(
                      Icons.timer,
                      color: Colors.lime,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.02),
                  child: Text(
                    numberFormatter
                        .format(_totalSales), 
                    style: GoogleFonts.aboreto(
                      fontSize: screenWidth * 0.1,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.total_sales_label,
                  style: GoogleFonts.abel(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.04,
                  ),
                  overflow: TextOverflow.fade,
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
