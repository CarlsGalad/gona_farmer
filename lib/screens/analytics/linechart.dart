import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({super.key});

  @override
  LineChartWidgetState createState() => LineChartWidgetState();
}

class LineChartWidgetState extends State<LineChartWidget> {
  List<double> monthlySales = []; // List to store monthly sales totals

  @override
  void initState() {
    super.initState();
    fetchMonthlySalesData();
  }

  Future<List<DateTime>> fetchMonthlySalesData() async {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Fetch sales data for the last six months from Firebase Firestore
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('sales')
          .where('farmId', isEqualTo: userId)
          .where('saleDate',
              isGreaterThan: Timestamp.fromDate(
                  DateTime.now().subtract(const Duration(days: 180))))
          .get();

      // Initialize lists to store sales amounts and sale dates
      List<double> monthlySales = [];
      List<DateTime> saleDates = [];

      // Calculate monthly sales totals and extract sale dates
      Map<int, double> monthlySalesMap = {};
      for (var doc in snapshot.docs) {
        DateTime saleDate = (doc['saleDate'] as Timestamp).toDate();
        saleDates.add(saleDate); // Store the sale date
        int month = saleDate.month;
        double saleAmount = doc['price'] * doc['quantity'];
        monthlySalesMap[month] = (monthlySalesMap[month] ?? 0) + saleAmount;
      }

      // Populate monthlySales list with monthly sales totals
      for (int i = 1; i <= 6; i++) {
        monthlySales.add(monthlySalesMap[i] ?? 0);
      }

      // Update UI after fetching data
      setState(() {});

      // Return both monthly sales and sale dates
      return saleDates;
    }

    // Return an empty list if no data is available
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DateTime>>(
      future: fetchMonthlySalesData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.green.shade100,
                  size:
                      50)); // Show a loading indicator while data is being fetched
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Show an error message if fetching data fails
        } else {
          // Data fetched successfully, now you can use it
          List<DateTime> saleDates = snapshot.data!;
          return LineChart(
            data1(monthlySales, saleDates),
          );
        }
      },
    );
  }

  LineChartData data1(List<double> monthlySales, List<DateTime> saleDates) {
    // Generate month labels from the sale dates
    List<String> monthLabels = saleDates.map((date) {
      return DateFormat.MMM().format(date);
    }).toList();

    return LineChartData(
      gridData: const FlGridData(show: true),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          axisNameWidget: Text(AppLocalizations.of(context)!.last_six_months),
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, _) {
              // Convert value to int and ensure it's within valid index range
              int index = value.toInt().clamp(0, monthLabels.length - 1);
              return Text(
                monthLabels[index],
                style: const TextStyle(color: Colors.black),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: Text(AppLocalizations.of(context)!.monthly_earnings),
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, _) {
              return Text('₦${value.toInt()}',
                  style: const TextStyle(color: Colors.black));
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
      lineBarsData: lineBarsData(monthlySales),
      minX: 0,
      maxX: 7,
      minY: 0,
      maxY: calculateMaxY(monthlySales),
    );
  }

  List<LineChartBarData> lineBarsData(List<double> monthlySales) {
    return [
      LineChartBarData(
        spots: List.generate(
          monthlySales.length,
          (index) => FlSpot(index.toDouble() + 1, monthlySales[index]),
        ),
        isCurved: true,
        color: Colors.green.shade100,
        barWidth: 3,
        isStrokeCapRound: true,
        belowBarData: BarAreaData(show: false),
        dotData: const FlDotData(show: false),
      ),
    ];
  }

  double calculateMaxY(List<double> monthlySales) {
    if (monthlySales.isEmpty) {
      return 0; // Return a default value or handle the case as needed
    }
    // Find the maximum sales amount for a month
    double maxSales = monthlySales
        .reduce((value, element) => value > element ? value : element);
    // Set the highest point to 10% more than the maximum sales amount
    return maxSales * 1.1;
  }
}
