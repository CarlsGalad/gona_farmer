import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:gona_vendor/screens/analytics/monthlist.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'linechart.dart';
import 'weekline.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  AnalyticsScreenState createState() => AnalyticsScreenState();
}

class AnalyticsScreenState extends State<AnalyticsScreen> {
  bool showLastSixMonths = false; // Toggle for last 30 days and this week

  void toggleChart() {
    setState(() {
      showLastSixMonths = !showLastSixMonths;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.analytics,
          style: GoogleFonts.aboreto(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                SizedBox(
                  height: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.top_ten_sold_items,
                        style: GoogleFonts.abel(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _fetchTopTenSoldItems(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                    color: Colors.green.shade100, size: 50));
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            final List<Map<String, dynamic>>? topTenItems =
                                snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: topTenItems!.map((
                                item,
                              ) {
                                return Text(
                                  '${item['itemName']} - ${item['quantity']} sold',
                                  style: GoogleFonts.abel(fontSize: 16),
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.performance_chart,
                  style: GoogleFonts.abel(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 350,
                  child: Column(
                    children: [
                      MaterialButton(
                        color: Colors.green.shade100,
                        elevation: 18,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        onPressed: toggleChart,
                        child: Text(
                          showLastSixMonths
                              ? AppLocalizations.of(context)!.show_this_week
                              : AppLocalizations.of(context)!
                                  .show_last_six_months,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: showLastSixMonths
                            ? const LineChartWidget()
                            : const WeekLineChartWidget(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  AppLocalizations.of(context)!.earnings_last_six_months,
                  style: GoogleFonts.abel(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 400,
                  child: MonthlyEarningsWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchTopTenSoldItems() async {
    // Query the sales collection to fetch the top ten sold items
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('sales')
        .orderBy('quantity', descending: true)
        .limit(10)
        .get();

    // Parse the query results and return the top ten sold items as a list of maps
    List<Map<String, dynamic>> topTenItems = querySnapshot.docs.map((doc) {
      return {
        'itemName': doc['itemName'],
        'quantity': doc['quantity'],
      };
    }).toList();

    return topTenItems;
  }
}
