import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _nairaFormat =
      NumberFormat.currency(locale: 'en_NG', symbol: '');

  static String format(int amount) {
    return _nairaFormat.format(amount);
  }
}
