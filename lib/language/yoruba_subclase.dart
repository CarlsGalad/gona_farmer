import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/date_symbol_data_local.dart' as date_symbol_data_custom;

class YoMaterialLocalizations extends GlobalMaterialLocalizations {
  const YoMaterialLocalizations({
    String yoruba = 'yo',
    required intl.NumberFormat decimalFormat,
    required intl.NumberFormat twoDigitZeroPaddedFormat,
    required intl.DateFormat fullYearFormat,
    required intl.DateFormat compactDateFormat,
    required intl.DateFormat shortDateFormat,
    required intl.DateFormat mediumDateFormat,
    required intl.DateFormat longDateFormat,
    required intl.DateFormat yearMonthFormat,
    required intl.DateFormat shortMonthDayFormat, required localeName,
  }) : super(
          localeName: yoruba,
          decimalFormat: decimalFormat,
          twoDigitZeroPaddedFormat: twoDigitZeroPaddedFormat,
          fullYearFormat: fullYearFormat,
          compactDateFormat: compactDateFormat,
          shortDateFormat: shortDateFormat,
          mediumDateFormat: mediumDateFormat,
          longDateFormat: longDateFormat,
          yearMonthFormat: yearMonthFormat,
          shortMonthDayFormat: shortMonthDayFormat,
        );

  @override
  String get moreButtonTooltip => 'Die e sii';

  @override
  String get aboutListTileTitleRaw => 'Nipa $applicationName';

  @override
  String get alertDialogLabel => 'Ikilọ';

  // Add more translations here...
}
class YoMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const YoMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'yo';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final String yoruba = intl.Intl.canonicalizedLocale(locale.toString());

    date_symbol_data_custom.initializeDateFormattingCustom(
      locale: yoruba,
      patterns: yoLocaleDatePatterns,
      symbols: intl.DateSymbols.deserializeFromMap(yoDateSymbols),
    );

    return SynchronousFuture<MaterialLocalizations>(
      YoMaterialLocalizations(
        localeName: yoruba,
        decimalFormat: intl.NumberFormat('#,##0.###', 'en_US'),
        twoDigitZeroPaddedFormat: intl.NumberFormat('00', 'en_US'),
        fullYearFormat: intl.DateFormat('y', yoruba),
        compactDateFormat: intl.DateFormat('yMd', yoruba),
        shortDateFormat: intl.DateFormat('yMMMd', yoruba),
        mediumDateFormat: intl.DateFormat('EEE, MMM d', yoruba),
        longDateFormat: intl.DateFormat('EEEE, MMMM d, y', yoruba),
        yearMonthFormat: intl.DateFormat('MMMM y', yoruba),
        shortMonthDayFormat: intl.DateFormat('MMM d'),
      ),
    );
  }

  @override
  bool shouldReload(YoMaterialLocalizationsDelegate old) => false;
}
const yoLocaleDatePatterns = {
  'd': 'd.',
  'E': 'ccc',
  'EEEE': 'cccc',
  'LLL': 'LLL',
  // Add more date patterns...
};

const yoDateSymbols = {
  'NAME': 'yo',
  'ERAS': <dynamic>[
    'SA',
    'LK',
  ],
  // Add more date symbols...
};
