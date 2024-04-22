import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MonthlyEarningsWidget extends StatefulWidget {
  const MonthlyEarningsWidget({super.key});

  @override
  MonthlyEarningsWidgetState createState() => MonthlyEarningsWidgetState();
}

class MonthlyEarningsWidgetState extends State<MonthlyEarningsWidget> {
  late List<MonthlyEarning> monthlyEarnings = [];

  @override
  void initState() {
    super.initState();
    fetchMonthlyEarningsData();
  }

  Future<void> fetchMonthlyEarningsData() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('sales')
          .where('farmId', isEqualTo: userId)
          .where('salesDate',
              isGreaterThan: Timestamp.fromDate(
                  DateTime.now().subtract(const Duration(days: 180))))
          .get();

      Map<String, double> monthlySalesMap = {};

      for (var doc in snapshot.docs) {
        DateTime saleDate = (doc['salesDate'] as Timestamp).toDate();
        String monthYearKey = '${saleDate.month}-${saleDate.year}';
        double saleAmount = doc['price'] * doc['quantity'];
        monthlySalesMap[monthYearKey] =
            (monthlySalesMap[monthYearKey] ?? 0) + saleAmount;
      }

      monthlyEarnings = [];
      monthlySalesMap.forEach((key, value) {
        List<String> parts = key.split('-');
        int month = int.parse(parts[0]);
        int year = int.parse(parts[1]);
        monthlyEarnings.add(MonthlyEarning(month, year, value));
      });

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: monthlyEarnings.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            '${_getMonthName(monthlyEarnings[index].month)} ${monthlyEarnings[index].year}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
              'Total Earnings: \$${monthlyEarnings[index].earnings.toStringAsFixed(2)}'),
        );
      },
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}

class MonthlyEarning {
  final int month;
  final int year;
  final double earnings;

  MonthlyEarning(this.month, this.year, this.earnings);
}
