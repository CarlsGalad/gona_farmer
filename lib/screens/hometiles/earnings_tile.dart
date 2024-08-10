import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:gona_vendor/models/helper/currency_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../analytics/analytics.dart';

class TotalEarningsDisplay extends StatelessWidget {
  const TotalEarningsDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const AnalyticsScreen())),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 15),
        child: Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 30,
            height: 150,
            child: FutureBuilder<DocumentSnapshot>(
              future: _fetchTotalEarnings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                          size: 30, color: Colors.green.shade100));
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          '${AppLocalizations.of(context)!.total_earnings_error} '
                          ' ${snapshot.error}'));
                } else {
                  int totalEarnings = snapshot.data?['totalEarnings'] ??
                      0; // Retrieve total earnings
                  // Format total earnings
                  return Padding(
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
                              Icons.monetization_on,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'NGN', // Currency symbol
                                  style: GoogleFonts.aboreto(
                                      fontSize: 25,
                                      fontWeight: FontWeight
                                          .bold // Smaller font size for the currency symbol
                                      ),
                                ),
                                TextSpan(
                                  text: CurrencyFormatter.format(totalEarnings)
                                      .replaceAll('NGN',
                                          ''), // Remove the currency symbol from the formatted amount
                                  style: GoogleFonts.aboreto(
                                    fontSize:
                                        45, // Larger font size for the amount
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: Text(
                            AppLocalizations.of(context)!.total_earnings_label,
                            style:
                                GoogleFonts.abel(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<DocumentSnapshot> _fetchTotalEarnings() async {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Fetch the farms document from Firestore
      return await FirebaseFirestore.instance
          .collection('farms')
          .doc(userId)
          .get();
    } else {
      // Return a default DocumentSnapshot if the user is not logged in
      return FirebaseFirestore.instance.doc('farms/default').get();
    }
  }

  String _formatNumber(int number) {
    // Use NumberFormat to format the number with commas
    return NumberFormat('#,##0').format(number);
  }
}
