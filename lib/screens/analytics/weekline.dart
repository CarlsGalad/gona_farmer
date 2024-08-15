import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class WeekLineChartWidget extends StatefulWidget {
  const WeekLineChartWidget({super.key});

  @override
  WeekLineChartWidgetState createState() => WeekLineChartWidgetState();
}

class WeekLineChartWidgetState extends State<WeekLineChartWidget> {
  List<double> weeklySales =
      List.filled(7, 0); // List to store weekly sales totals

  @override
  void initState() {
    super.initState();
    fetchWeeklySalesData();
  }

  Future<void> fetchWeeklySalesData() async {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Fetch sales data for the last week from Firebase Firestore
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('sales')
          .where('farmId', isEqualTo: userId)
          .where('saleDate',
              isGreaterThan: Timestamp.fromDate(
                  DateTime.now().subtract(const Duration(days: 7))))
          .get();

      // Initialize list to store sales amounts for each day of the week
      List<double> dailySales = List.filled(7, 0);

      // Calculate weekly sales totals
      for (var doc in snapshot.docs) {
        DateTime saleDate = (doc['saleDate'] as Timestamp).toDate();
        int dayOfWeek =
            saleDate.weekday - 1; // Adjust day of week to be 0-based index
        double saleAmount = doc['price'] * doc['quantity'];
        dailySales[dayOfWeek] += saleAmount;
      }

      // Update UI after fetching data
      setState(() {
        weeklySales = dailySales;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      data1(weeklySales),
    );
  }

  LineChartData data1(List<double> weeklySales) {
    return LineChartData(
      gridData: const FlGridData(show: true),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          axisNameWidget: Text(
            AppLocalizations.of(context)!.this_week,
            style: GoogleFonts.abel(),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, _) {
              // Convert value to int and map to day of the week
              int day = value.toInt();
              switch (day) {
                case 0:
                  return Text(AppLocalizations.of(context)!.mon,
                      style: GoogleFonts.abel(color: Colors.black));
                case 1:
                  return Text(AppLocalizations.of(context)!.tue,
                      style: GoogleFonts.abel(color: Colors.black));
                case 2:
                  return Text(AppLocalizations.of(context)!.wed,
                      style: GoogleFonts.abel(color: Colors.black));
                case 3:
                  return Text(AppLocalizations.of(context)!.thu,
                      style: GoogleFonts.abel(color: Colors.black));
                case 4:
                  return Text(AppLocalizations.of(context)!.fri,
                      style: GoogleFonts.abel(color: Colors.black));
                case 5:
                  return Text(AppLocalizations.of(context)!.sat,
                      style: GoogleFonts.abel(color: Colors.black));
                case 6:
                  return Text(AppLocalizations.of(context)!.sun,
                      style: GoogleFonts.abel(color: Colors.black));
                default:
                  return const SizedBox();
              }
            },
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: Text(
            AppLocalizations.of(context)!.this_weeks_earnings,
            style: GoogleFonts.abel(fontStyle: FontStyle.italic),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, _) {
              return Text('₦${value.toInt()}');
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff37434d),
            width: 3,
          ),
          left: BorderSide(
            color: Color(0xff37434d),
            width: 1,
          ),
          top: BorderSide(
            color: Colors.transparent,
            width: 1,
          ),
          right: BorderSide(
            color: Colors.transparent,
            width: 1,
          ),
        ),
      ),
      lineBarsData: lineBarsData(weeklySales),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: weeklySales
              .reduce((value, element) => value > element ? value : element) *
          1.1,
    );
  }

  List<LineChartBarData> lineBarsData(List<double> weeklySales) {
    return [
      LineChartBarData(
        spots: List.generate(
          weeklySales.length,
          (index) => FlSpot(index.toDouble(), weeklySales[index]),
        ),
        isCurved: true,
        color: Colors.green,
        barWidth: 3,
        isStrokeCapRound: true,
        belowBarData: BarAreaData(show: false),
        dotData: const FlDotData(show: false),
      ),
    ];
  }
}
