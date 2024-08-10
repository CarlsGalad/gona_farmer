import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

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
          leading: Text('${index + 1}.'),
          title: Text(
            ' ${_getMonthName(monthlyEarnings[index].month)} ${monthlyEarnings[index].year}',
            style: GoogleFonts.abel(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${AppLocalizations.of(context)!.total_earnings}: \$${monthlyEarnings[index].earnings.toStringAsFixed(2)}',
            style: GoogleFonts.abel(),
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return AppLocalizations.of(context)!.january;
      case 2:
        return AppLocalizations.of(context)!.february;
      case 3:
        return AppLocalizations.of(context)!.march;
      case 4:
        return AppLocalizations.of(context)!.april;
      case 5:
        return AppLocalizations.of(context)!.may;
      case 6:
        return AppLocalizations.of(context)!.june;
      case 7:
        return AppLocalizations.of(context)!.july;
      case 8:
        return AppLocalizations.of(context)!.august;
      case 9:
        return AppLocalizations.of(context)!.september;
      case 10:
        return AppLocalizations.of(context)!.october;
      case 11:
        return AppLocalizations.of(context)!.november;
      case 12:
        return AppLocalizations.of(context)!.december;
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
